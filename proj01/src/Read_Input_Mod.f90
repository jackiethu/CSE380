! module to read input file
module Read_Input_Mod
    implicit none

contains

    subroutine Read_Input ! read control parameters from file
        use Control_Parameters_Mod
        use grvy
        implicit none
        character(len = 20) :: filename = "input.dat"
        integer :: flag

        ! log time
        call grvy_timer_begin('Read_Input')
        
        ! initialize/read the file
        call grvy_input_fopen(filename, flag)

        ! read variables
        call grvy_input_fread_int("dimen", dimen, flag)
        call grvy_input_fread_double("side_Length", side_Length, flag)
        call grvy_input_fread_int("num_Mesh", num_Mesh, flag)

        call grvy_input_fread_int("order", order, flag)
        call grvy_input_fread_int("solver_Flag", solver_Flag, flag)

        call grvy_input_fread_int("verification_Flag", verification_Flag, flag)
        call grvy_input_fread_int("debug_Flag", debug_Flag, flag)

        call grvy_input_fread_double("k_0", k_0, flag)

        call grvy_input_fread_double("eps", eps, flag)
        call grvy_input_fread_int("max_iter", max_iter, flag)
        call grvy_input_fread_int("print_iter", print_iter, flag)
        call grvy_input_fread_char("output_file", output_file, flag)

        ! close the file
        call grvy_input_fclose

        ! in debug mode, output control parameters
        if (debug_Flag == 1 .or. debug_Flag == 2) then
            write(*, "('----- CONTROL PARAMETERS -----')")
            write(*, "(A20, I2)") "dimen: ", dimen
            write(*, "(A20, F6.3)") "side_Length: ", side_Length
            write(*, "(A20, I6)") "num_Mesh: ", num_Mesh

            write(*, "(A20, I2)") "order: ", order
            write(*, "(A20, I2)") "solver_Flag: ", solver_Flag

            write(*, "(A20, I2)") "verification_Flag: ", verification_Flag
            write(*, "(A20, I2)") "debug_Flag: ", debug_Flag

            write(*, "(A20, F6.3)") "k_0: ", k_0

            write(*, "(A20, E10.3)") "eps: ", eps
            write(*, "(A20, I6)") "max_iter: ", max_iter
            write(*, "(A20, I6)")  "print_iter: ", print_iter
            write(*, "(A20, A50)") "output_file: ", output_file
            
            write(*,*)
        end if

        call grvy_timer_end('Read_Input')

    end subroutine Read_Input

end module Read_Input_Mod
