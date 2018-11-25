! module to generate source term (b in eq Ax = b)
module Get_Source_Mod
    implicit none
    real, parameter :: PI = 3.1415926535897932

contains

    subroutine Get_Source_1D
        ! output: b for 1D problem

        use Solve_Common_Mod, only : b, h, x_Coord
        use Control_Parameters_Mod, only : k_0
        use masa
        implicit none
        integer :: i
        integer :: n ! b is an (n+1)*1 vector

        if (.not. allocated(b)) stop "b has not been allocated"
        n = size(b) - 1

        ! initialize MASA program and set parameters
        call masa_init("mytest", "heateq_1d_steady_const")
        call masa_set_param("k_0", k_0)
        call masa_set_param("A_x", 2*PI)
        call masa_display_param
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


    end subroutine Get_Source_2D

end module Get_Source_Mod
