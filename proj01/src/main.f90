! main program to solve steady-state heat equation
program main
    use Read_Input_Mod, only : Read_Input ! module to read input
    use Initialize_Mod, only : Initialize ! module to initialize matrix & vec
    implicit none

    ! open control file "input.dat" and read control parameters
    call Read_Input

    ! initialize matrix and vectors
    call Initialize


end program main
