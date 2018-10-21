! module file for trapezoid and Simpson integral
module Integral_Mod
    implicit none
    
contains

    ! subroutine to generate discrete functional values
    subroutine Generate_Data(datas, n, Func)
        implicit none
        real(kind = 8), intent(out) :: datas(0:n) ! discrete func values
        integer, intent(in) :: n ! number of intervals
        real(kind = 8), external :: Func ! function to integrate
        real(kind = 8) :: x  ! x coordinate to evaluate func
        real(kind = 8) :: dx ! mesh size
        integer i ! temp variable used in loop

        dx = 1.0 / real(n)
        x = 0.0 
        do i = 0, n
            datas(i) = Func(x)
            x = x + dx
        end do
    end subroutine

    ! Integration using trapezoidal rule
    real function Integral_Trapezoid(datas, n)
        implicit none
        real(kind = 8), intent(in) :: datas(0:n)
        integer, intent(in) :: n
        real(kind = 8) :: dx ! mesh size
        integer :: i ! temp variable for loop use
        real(kind = 8) :: sum

        dx = 1.0 / real(n)
        sum = (datas(0) + datas(n)) / 2.0
        do i = 1, n-1
            sum = sum + datas(i)
        end do
        
        Integral_Trapezoid = sum*dx
        return
    end function
    
    ! Integration using Simpson's rule
!    real function Integral_Simpson(datas, n)
!        real, intent(in) :: datas(0:n)
!        integer, intent(in) :: n
!        real :: dx ! mesh size
!        integer :: i ! temp variable for loop use
!        real :: sum
!
!        dx = 1.0 / real(n)
!        sum = (datas(0) + datas(n)) / 2.0
!        do i = 1, n-1
!            sum = sum + datas(i)
!        end do
!        
!        Integral_Trapezoid = sum*dx
!        return
!
!    end function
        
end module
