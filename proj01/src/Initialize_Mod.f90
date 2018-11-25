! module to initialize matrix and vectors based on specific problem
module Initialize_Mod
    implicit none

contains

    subroutine Initialize
        use Control_Parameters_Mod, only : dimen, order, num_Mesh, debug_Flag
        use Solve_Common_Mod, only : A, x, b
        use Get_Matrix_Mod, only : Get_Matrix_1D_Order2, Get_Matrix_1D_Order4, &
                                   Get_Matrix_2D_Order2, Get_Matrix_2D_Order4 
        use Get_Source_Mod, only : Get_Source_1D, Get_Source_2D
        use Get_Mesh_Mod, only : Get_Mesh
        implicit none
        integer :: dof  ! total degrees of freedom
        integer :: ierr ! error indicator
        integer :: i ! temp variable in loop
        
        select case(dimen)
        case(1) ! 1D problem

            ! compute total dof
            dof = num_Mesh + 1

            ! allocate storage for A, x, and b
            call A%Init(dof)
            allocate( x(dof), stat = ierr )
            if (ierr /= 0) stop "unable to allocate x"
            allocate( b(dof), stat = ierr )
            if (ierr /= 0) stop "unable to allocate b"
            
            ! initialize A according to discretization rule
            if (order == 2) then
                call Get_Matrix_1D_Order2
            else if (order == 4) then
                call Get_Matrix_1D_Order4
            else
                stop "discretization order must be 2 or 4"
            end if

            ! initialize mesh and b
            call Get_Mesh
            call Get_Source_1D

        case(2) ! 2D problem

            ! compute total dof
            dof = (num_Mesh + 1) * (num_Mesh + 1)

            ! allocate storage for A, x, and b
            call A%Init(dof)
            allocate( x(dof), stat = ierr )
            if (ierr /= 0) stop "unable to allocate x"
            allocate( b(dof), stat = ierr )
            if (ierr /= 0) stop "unable to allocate b"

            ! initialize A according to discretization rule
            if (order == 2) then
                call Get_Matrix_2D_Order2
            else if (order == 4) then
                call Get_Matrix_2D_Order4
            else
                stop "discretization order must be 2 or 4"
            end if

            ! initialize mesh and b
            call Get_Mesh
            call Get_Source_2D            

        case default

            stop "invalid dimension"

        end select

        ! in debug mode, output matrix A and RHS term b
        if (debug_Flag == 1) then
            ! output A
            call A%Print_Matrix

            ! output b
            write(*, "('----- RHS: b -----')")
            do i = 1, size(b)
                write(*, "('b(', I2, ') = ', E13.6)") i, b(i)
            end do
            write(*, *)
        end if

    end subroutine Initialize

end module Initialize_Mod
