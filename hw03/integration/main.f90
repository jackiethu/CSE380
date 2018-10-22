! program main for integration to get error function
program main
    use Integral_Mod
    use Err_Function_Mod
    use Str2int_Mod
    implicit none
    integer :: n ! number of intervals used for integration
    character(len = 10) :: str ! used to read cmd line arguments
    integer :: str_Len ! length for str
    character(len = 10) :: rule
    integer :: error ! error indicator
    real(kind = 8) :: erf ! erf(1), the integration result
    real(kind = 8), parameter :: erf_tab = 0.84270079295_8

    !write(*,*) "Usage: ./integrate N rule(trapezoid or Simpson)"
    ! read in command line argument
    call get_command_argument(1, str, str_Len, error)
    if (error /= 0) stop "Cannot get the 1st argument"
    call Str2int(str(1:str_Len), n, error)
    call get_command_argument(2, str, str_Len, error)
    if (error /= 0) stop "Cannot get the 2nd argument"
    rule = str
    
    ! select integration rule based on 2nd command line argument
    select case(trim(rule))
    case("trapezoid")
        erf = Integral_Trapezoid(Err_Function, n)
    case("Simpson")
        erf = Integral_Simpson(Err_Function, n)
    case default
        stop "invalid integration rule"
    end select

    ! output results
    !write(*, *) "n = ", n
    !write(*, *) "integration rule: ", rule
    !write(*, *) "erf(1) = ", erf
    !write(*, *) "absolute error: ", abs(erf - erf_tab)

    write(*, "(I5, 1X, E15.7)") n, abs(erf - erf_tab)

end program
