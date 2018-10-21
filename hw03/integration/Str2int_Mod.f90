! module to convert string to integer
module Str2int_Mod
contains

    subroutine Str2int(str, int, stat)
        implicit none
        character(len = *), intent(in) :: str
        integer, intent(out) :: int
        integer, intent(out) :: stat

        read(str, *, iostat = stat) int
    end subroutine

end module
