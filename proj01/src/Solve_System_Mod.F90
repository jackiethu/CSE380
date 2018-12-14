! module to solve linear system Ax = b using iterative method
! input: A, b
! output: x
module Solve_System_Mod
    implicit none

contains
    
    subroutine Solve_System
        use Solve_Common_Mod, only : A, x, b
        use Jacobi_GS_Mod, only : Update_Jacobi, Update_GS
        use Control_Parameters_Mod, only : eps, max_iter, solver_Flag, &
                                           debug_Flag, print_iter
        use grvy
        implicit none

        integer :: i, n
        real, allocatable, dimension(:) :: x_new
        integer :: ierr ! error indicator
        real :: err ! difference in x between two iterations

        call grvy_timer_begin('Solve_System')

#ifdef INCLUDE_PETSC        
        if (solver_Flag == 3) then ! use petsc to solve the system
            call Solve_System_GMRES
            call grvy_timer_end('Solve_System')
            return
        end if
#else
        if (solver_Flag == 3) then
            stop "PETSc is not enabled"
        end if
#endif
        
        ! allocate x_new
        n = size(x)
        allocate(x_new(n), stat = ierr)
        if (ierr /= 0) stop "unable to allocate x_new"

        ! initialize x
        x = 0

        ! iteration
        do i = 1, max_iter

            ! choose update scheme based on solver flag
            select case(solver_Flag)
            case(1)
                x_new = Update_Jacobi(A, x, b)
            case(2)
                x_new = Update_GS(A, x, b)
            case default
                stop "invalid solver_Flag"
            end select

            ! compute error and update x
            err = norm2(x_new - x) / sqrt( real(n) )
            x = x_new

            ! in debug mode, output error every print_iter iterations
            if (mod(i, print_iter) == 0) then
                if (debug_Flag == 1 .or. debug_Flag == 2) then
                    write(*,"('iteration count: ', I6)") i
                    write(*,"('err = ', E13.6)") abs(err)
                end if
            end if      
            
            ! if error is less than eps, exit
            if (err <= eps) then
                exit
            end if

        end do

        ! in debug mode, output iteration count and error
        if (debug_Flag == 1 .or. debug_Flag == 2) then
            write(*,*)
            select case(solver_Flag)
            case(1)
                write(*, "('----- JACOBI METHOD -----')")
            case(2)
                write(*, "('----- GAUSS-SEIDEL METHOD -----')")
            case default
                stop "invalid solver_Flag"
            end select
            
            write(*,"('iteration count: ', I6)") i
            write(*,"('err = ', E13.6)") abs(err)
            write(*,*)
        end if

        call grvy_timer_end('Solve_System')

    end subroutine


#ifdef INCLUDE_PETSC

    subroutine Solve_System_GMRES
#include "petsc/finclude/petsc.h"
        use petsc
        use Solve_Common_Mod, only : A, x, b
        use Control_Parameters_Mod, only: dimen, order, debug_Flag
        implicit none

        Mat Matrix
        Vec Rhs, Soln
        KSP Solve
        PetscErrorCode ierr
        PetscInt n 
        PetscInt num_Nonzero ! number of nonzeros per row in matrix A
        integer, dimension(:), allocatable :: ix ! indices to set vec values
        integer :: i
        integer :: error ! error indicator for allocation
        PetscScalar, pointer :: xx_v(:) ! used to get the array from Vec
        
        ! initialize petsc
        call PetscInitialize(PETSC_NULL_CHARACTER, ierr)
        if (ierr /= 0) then
          print*,'Unable to initialize PETSc'
          stop
        endif
        print *, "Initialization finished"

        !
        ! create vectors
        !
        n = size(x)
        call VecCreateSeq(PETSC_COMM_SELF, n, Rhs, ierr)
        call VecDuplicate(Rhs, Soln, ierr)

        ! set Rhs values
        allocate(ix(n), stat = error)
        if (error /= 0) stop "unable to allocate ix"
        do i = 1, n
            ix(i) = i - 1
        end do
        call VecSetValues(Rhs, n, ix, b, INSERT_VALUES, ierr)

        ! assemble vectors
        call VecAssemblyBegin(Rhs, ierr)
        call VecAssemblyEnd(Rhs, ierr)
        call VecAssemblyBegin(Soln, ierr)
        call VecAssemblyEnd(Soln, ierr)

        ! view vectors
        if (debug_Flag == 2) then
            call VecView(Rhs, PETSC_VIEWER_STDOUT_SELF, ierr)
        end if
        
        !
        ! create matrix
        !
        ! first set number of nonzero values on each row
        select case(dimen)
        case(1)
            select case(order)
            case(2)
                num_Nonzero = 3
            case(4)
                num_Nonzero = 5
            end select
        case(2)
            select case(order)
            case(2)
                num_Nonzero = 5
            case(4)
                num_Nonzero = 9
            end select
        end select
        ! then create matrix
        call MatCreateSeqAIJ(PETSC_COMM_SELF, n, n, num_Nonzero, &
            PETSC_NULL_INTEGER, Matrix, ierr)
        print *, "Matrix created"

        ! set matrix entries
        do i = 1, n ! set mat values by row
            call MatSetValues(Matrix, 1, i-1, A%row(i)%num_Nonzero, &
                A%row(i)%indices-1, A%row(i)%values, INSERT_VALUES, ierr)
        end do

        ! assemble matrix
        call MatAssemblyBegin(Matrix, MAT_FINAL_ASSEMBLY, ierr)
        call MatAssemblyEnd(Matrix, MAT_FINAL_ASSEMBLY, ierr)

        ! view matrix
        if (debug_Flag == 2) then
            call MatView(Matrix, PETSC_VIEWER_STDOUT_SELF, ierr)
        end if

        !
        ! create linear solver context
        !
        call KSPCreate(PETSC_COMM_SELF, Solve, ierr)
        call KSPSetOperators(Solve, Matrix, Matrix, ierr)

        !
        ! solve linear system
        !
        call KSPSolve(Solve, Rhs, Soln, ierr)

        ! view solution
        if (debug_Flag == 2) then
            call VecView(Soln, PETSC_VIEWER_STDOUT_SELF, ierr)
        end if

        ! get solution from petsc struct
        call VecGetArrayReadF90(Soln, xx_v, ierr)
        x = xx_v
        !print *, "Soln: ", x
        call VecRestoreArrayReadF90(Soln, xx_v, ierr)
    
        ! destroy vectors
        call VecDestroy(Rhs, ierr)
        call VecDestroy(Soln, ierr)

        ! destroy matrix
        call MatDestroy(Matrix, ierr)

        ! destroy solver
        call KSPDestroy(Solve, ierr)

        ! finalize petsc
        call PetscFinalize(ierr)


    end subroutine Solve_System_GMRES

#endif

end module Solve_System_Mod
