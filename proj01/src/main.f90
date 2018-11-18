! main program to solve steady-state heat equation
program main
    use Control_Parameters_Mod ! module containing control parameters
    use Read_Input_Mod, only : Read_Input ! module to read input
    use Initialize_Mod, only : Initialize ! module to initialize matrix & vec
    implicit none

    ! open control file "input.dat" and read control parameters
    call Read_Input
    if (debug_Flag == 1) then ! in debug mode, output control parameters
        write(*, "(A20, I2)") "dimen: ", dimen
        write(*, "(A20, I2)") "order: ", order
        write(*, "(A20, I2)") "solver_Flag: ", solver_Flag
        write(*, "(A20, I6)") "num_Mesh: ", num_Mesh
        write(*, "(A20, I2)") "verification_Flag: ", verification_Flag
        write(*, "(A20, I2)") "debug_Flag: ", debug_Flag
    end if

    ! initialize matrix and vectors
    call Initialize


end program main
