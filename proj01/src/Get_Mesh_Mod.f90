! module to initialize mesh
module Get_Mesh_Mod
    implicit none

contains

    subroutine Get_Mesh
        use Solve_Common_Mod, only : x_Coord, y_Coord, h
        use Control_Parameters_Mod, only : dimen, side_Length, num_Mesh, &
                                            debug_Flag
        implicit none
        integer :: ierr ! error indicator
        integer :: i ! temporary variable in loop

        ! allocate storage for coordinates
        allocate(x_Coord(0:num_Mesh), stat = ierr)
        if (ierr /= 0) stop "unable to allocate x_Coord"

        if (dimen == 2) then
            allocate(y_Coord(0:num_Mesh), stat = ierr)
            if (ierr /= 0) stop "unable to allocate y_Coord"
        end if

        ! distance between adjacent grid points
        h = side_Length/real(num_Mesh)

        do i = 0, num_Mesh
            x_Coord(i) = real(i)*h
        end do

        if (dimen == 2) y_Coord = x_Coord
        
        ! in verbose debug mode, output mesh coordinates
        if (debug_Flag == 2) then
            write(*,"('----- MESH -----')")
            do i = 0, num_Mesh
                write(*,"('x_Coord(', I2 ,') = ', F6.3)") i, x_Coord(i)
            end do
            write(*,*)
        end if

    end subroutine

end module Get_Mesh_Mod
