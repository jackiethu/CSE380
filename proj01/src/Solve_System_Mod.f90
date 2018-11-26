! module to solve linear system Ax = b using iterative method
module Solve_System_Mod
    implicit none

contains
    
    subroutine Solve_System
        use Solve_Common_Mod, only : A, x, b
        use Jacobi_GS_Mod, only : Update_Jacobi, Update_GS
        use Control_Parameters_Mod, only : eps, max_iter, solver_Flag, &
                                           debug_Flag, print_iter
        implicit none

        integer :: i, n
        real, allocatable, dimension(:) :: x_new
        integer :: ierr ! error indicator
        real :: err ! difference in x between two iterations

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
            if (err <= eps) exit
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

    end subroutine

end module Solve_System_Mod
