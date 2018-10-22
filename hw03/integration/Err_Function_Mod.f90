! module file to define the integrand of error function
module Err_Function_Mod
    implicit none
    private
    public Err_Function
    real, parameter :: PI = 3.1415926535897932

contains
    real function Err_Function(x)
        real, intent(in) :: x
        Err_Function = 2.0/sqrt(PI)*exp(-x*x)
        return
    end function

end module
