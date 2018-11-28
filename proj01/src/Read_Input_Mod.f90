! module to read input file
module Read_Input_Mod
    implicit none

contains

    subroutine Read_Input ! read control parameters from file
        use Control_Parameters_Mod
        use grvy
        implicit none
        character(len = 20) :: filename = "input.dat"
        character(len = 20) :: string
        integer :: string_Length
        integer :: flag
        integer :: ierr ! does command argument exist?
        integer :: alive ! if file exists or not

        ! log time
        call grvy_timer_begin('Read_Input')
        
        ! get input file name from command line argument
        ! if no arg supplied, use default "input.dat"
        call get_command_argument(1, string, string_Length, ierr)
        if (ierr == 0) then
            filename = string
        end if

        ! check if input file exists
        inquire(file = filename, exist = alive)
        if (.not. alive) then
            print *, filename, "doesn't exist!"
            stop
        end if

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
        call grvy_input_fread_int("max_Iter", max_Iter, flag)
        call grvy_input_fread_int("print_Iter", print_Iter, flag)
        call grvy_input_fread_char("output_File", output_File, flag)

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
            write(*, "(A20, I6)") "max_Iter: ", max_Iter
            write(*, "(A20, I6)")  "print_Iter: ", print_Iter
            write(*, "(A20, A50)") "output_File: ", output_File
            
            write(*,*)
        end if

        call grvy_timer_end('Read_Input')

    end subroutine Read_Input

end module Read_Input_Mod
