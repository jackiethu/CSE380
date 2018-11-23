! module to initialize matrix and vector based on specific problem
module Initialize_Mod
    implicit none

contains

    subroutine Initialize
        use Control_Parameters_Mod, only : dimen, order, num_Mesh, debug_Flag
        use Solve_Common_Mod, only : A, x, b
        use Get_Matrix_Mod, only : Get_Matrix_1D_Order2, Get_Matrix_1D_Order4, &
                                   Get_Matrix_2D_Order2, Get_Matrix_2D_Order4 
        implicit none
        integer :: dof  ! total degrees of freedom
        integer :: ierr ! error indicator
        
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

            ! initialize b

            ! need to be completed

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

            ! initialize b
            
            ! to be completed

        case default
            stop "invalid dimension"
        end select

        ! in debug mode, output matrix
        if (debug_Flag == 1) then
            call A%Print_Matrix
        end if

    end subroutine Initialize

end module Initialize_Mod
