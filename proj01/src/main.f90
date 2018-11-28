! main program to solve steady-state heat equation
program main
    use Read_Input_Mod, only : Read_Input ! module to read input
    use Initialize_Mod, only : Initialize ! module to initialize matrix & vec
    use Solve_System_Mod, only : Solve_System ! module to solve linear system
    use Postprocess_Mod, only : Postprocess ! module to compute error and output
    use Control_Parameters_Mod, only : debug_Flag
    use grvy ! we used the timing utility here
    implicit none

    ! initialize the timing library
    call grvy_timer_init('Heat Equation Solver')

    ! open control file "input.dat" and read control parameters
    call Read_Input

    ! initialize and build matrix and vectors A, x, b
    call Initialize

    ! solve the linear system Ax = b
    call Solve_System

    ! postprocessing (compute error norm and output)
    call Postprocess

    ! finalize the main program timer
    call grvy_timer_finalize

    ! in debug mode, print performance summary to stdout
    if (debug_Flag == 1 .or. debug_Flag == 2) then
        call grvy_timer_summarize
    end if


end program main
