! module to generate source term (b in eq Ax = b)
module Get_Source_Mod
    implicit none
    real, parameter :: PI = 3.1415926535897932

contains

    subroutine Get_Source_1D
        ! output: b for 1D problem

        use Solve_Common_Mod, only : b, h, x_Coord
        use Control_Parameters_Mod, only : k_0, num_Mesh, debug_Flag
        use masa
        implicit none
        integer :: i
        integer :: n ! b is an (n+1)*1 vector

        if (.not. allocated(b)) stop "b has not been allocated"
        n = num_Mesh

        ! initialize MASA program and set parameters
        call masa_init("mytest", "heateq_1d_steady_const")
        call masa_set_param("k_0", k_0)
        call masa_set_param("A_x", 2*PI)
        if (debug_Flag == 1) then
            call masa_display_param
        end if
        write(*,*)
        
        ! apply Dirichlet bc
        b(1) = masa_eval_1d_exact_t( x_Coord(0) )
        b(n+1) = masa_eval_1d_exact_t( x_Coord(n) )

        ! apply source field inside
        do i = 2, n
            b(i) = -masa_eval_1d_source_t( x_Coord(i-1) )*h*h/k_0
        end do

    end subroutine Get_Source_1D

    
    subroutine Get_Source_2D
        ! output: b for 2D problem

        use Solve_Common_Mod, only : b, h, x_Coord, y_Coord
        use Control_Parameters_Mod, only : k_0, num_Mesh, debug_Flag
        use masa
        implicit none
        integer :: i, j ! temp variable in loops
        integer :: i_row ! row number in b
        integer :: n ! n is the number of intervals in each direction

        if (.not. allocated(b)) stop "b has not been allocated"
        n = num_Mesh ! b is an (n+1)^2 * 1 vector

        ! initialize MASA program and set parameters
        call masa_init("mytest", "heateq_2d_steady_const")
        call masa_set_param("k_0", k_0)
        call masa_set_param("A_x", 2*PI)
        call masa_set_param("B_y", 2*PI)
        if (debug_Flag == 1) then
            call masa_display_param
        end if
        write(*,*)

        ! first block (n+1 lines, corresponding to j = 0)
        do i = 0, n
            b(i+1) = masa_eval_2d_exact_t( x_Coord(i), y_Coord(0) )
        end do

        ! last block
        do i = 0, n
            i_row = n*(n+1) + i + 1
            b(i_row) = masa_eval_2d_exact_t( x_Coord(i), y_Coord(n) )
        end do

        ! 2nd to nth block ( j = 1, n-1 )
        do j = 1, n-1
            ! first line in block (Dirichlet bc)
            i_row = j*(n+1) + 1
            b(i_row) = masa_eval_2d_exact_t( x_Coord(0), y_Coord(j) )

            ! last line in block (Dirichlet bc)
            i_row = j*(n+1) + n + 1
            b(i_row) = masa_eval_2d_exact_t( x_Coord(n), y_Coord(j) )

            ! 2nd to nth line (source term inside)
            do i = 1, n-1
                i_row = j*(n+1) + i + 1
                b(i_row) = -masa_eval_2d_source_t( x_Coord(i), y_Coord(j) ) &
                    *h*h/k_0
            end do
        end do

    end subroutine Get_Source_2D

end module Get_Source_Mod
