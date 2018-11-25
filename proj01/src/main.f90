! main program to solve steady-state heat equation
program main
    use Read_Input_Mod, only : Read_Input ! module to read input
    use Initialize_Mod, only : Initialize ! module to initialize matrix & vec
    use Solve_System_Mod, only : Solve_System ! module to solve linear system
    implicit none

    ! open control file "input.dat" and read control parameters
    call Read_Input

    ! initialize and build matrix and vectors A, x, b
    call Initialize

    ! solve the linear system Ax = b
    call Solve_System

    ! postprocessing


end program main
