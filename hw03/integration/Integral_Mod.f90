! module file for trapezoid and Simpson integral
module Integral_Mod
    implicit none
    
contains

    ! Integration using trapezoidal rule
    real function Integral_Trapezoid(Func, n)
        implicit none
        real(kind =8), external:: Func ! function to integrate
        integer, intent(in) :: n ! number of intervals
        real(kind = 8) :: x ! x coordinate to evaluate Func
        real(kind = 8) :: dx ! mesh size
        integer :: i ! temp variable for loop use
        real(kind = 8) :: sum = 0.0

        dx = 1.0 / real(n)
        x = 0.0
        do i = 1, n
            sum = sum + (Func(x) + Func(x+dx))/2.0
            x = x + dx
        end do        
        Integral_Trapezoid = sum*dx
        return
    end function
    
    ! Integration using Simpson's rule
    real function Integral_Simpson(Func, n)
        implicit none
        real(kind =8), external:: Func ! function to integrate
        integer, intent(in) :: n ! number of intervals
        real(kind = 8) :: x ! x coordinate to evaluate Func
        real(kind = 8) :: dx ! mesh size
        integer :: i ! temp variable for loop use
        real(kind = 8) :: sum = 0.0

        dx = 1.0 / real(n)
        x = 0.0
        do i = 1, n
            sum = sum + (Func(x) + 4*Func(x+0.5*dx) + Func(x+dx))/6.0
            x = x + dx
        end do        
        Integral_Simpson = sum*dx
        return
    end function
        
end module
