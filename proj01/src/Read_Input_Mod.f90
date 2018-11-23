! module to read input file
module Read_Input_Mod
    implicit none

contains

    subroutine Read_Input ! read control parameters from file
        use Control_Parameters_Mod
        implicit none
        integer, parameter :: fileid = 10 ! input file unit
        character(len = 20) :: filename = "input.dat"
        logical :: alive ! store if file exists
        integer :: stat ! iostat

        ! check if input file exists
        inquire(file = filename, exist = alive)
        if (.not. alive) then
            print *, filename, "doesn't exist"
            stop
        end if

        ! open input file
        open(unit = fileid, file = filename, status = 'old', iostat = stat)
        if (stat /= 0) then
            print *, "unable to open", filename
            stop
        end if
        
        ! read data from input file
        read(fileid, *) dimen
        read(fileid, *) order
        read(fileid, *) solver_Flag
        read(fileid, *) num_Mesh
        read(fileid, *) verification_Flag
        read(fileid, *) debug_Flag

        ! close input file
        close(fileid, iostat = stat)
        if (stat /= 0) then
            print *, "unable to close", filename
            stop
        end if

        ! in debug mode, output control parameters
        if (debug_Flag == 1) then
            write(*, "('----- CONTROL PARAMETERS -----')")
            write(*, "(A20, I2)") "dimen: ", dimen
            write(*, "(A20, I2)") "order: ", order
            write(*, "(A20, I2)") "solver_Flag: ", solver_Flag
            write(*, "(A20, I6)") "num_Mesh: ", num_Mesh
            write(*, "(A20, I2)") "verification_Flag: ", verification_Flag
            write(*, "(A20, I2)") "debug_Flag: ", debug_Flag
            write(*,*)
        end if

    end subroutine Read_Input

end module Read_Input_Mod
