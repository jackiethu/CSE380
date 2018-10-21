! program main for integration to get error function
program main
    use Integral_Mod
    use Err_Function_Mod
    use Str2int_Mod
    implicit none
    integer :: n = 10 ! number of intervals used for integration
    character(len = 10) :: str ! temporary variable
    integer :: str_Len ! length for str
    character(len = 10) :: rule
    real(kind = 8), allocatable :: datas(:)
    integer :: error ! error indicator
    real(kind = 8) :: ans ! integration result

    ! read in command line argument
    call get_command_argument(1, str, str_Len, error)
    if (error /= 0) stop "Cannot get the 1st argument"
    call Str2int(str(1:str_Len), n, error)
    call get_command_argument(2, str, str_Len, error)
    if (error /= 0) stop "Cannot get the 2nd argument"
    rule(1:str_Len) = str
    
    ! allocate memory for datas
    allocate(datas(0:n), stat = error)
    if (error /= 0) stop "Allocation error."
    
    call Generate_Data(datas, n, Err_Function)
    ans = Integral_Trapezoid(datas, n)

    write(*, *) "n = ", n
    write(*, *) "integration rule: ", rule
    write(*, *) "erf(1) = ", ans

    deallocate(datas)

end program 
