! module to postprocess: compute error norm and output
module Postprocess_Mod
    implicit none
contains

    subroutine Postprocess
        use Solve_Common_Mod, only : x, x_Coord, y_Coord
        use Control_Parameters_Mod, only : dimen, num_Mesh, verification_Flag, &
                                           output_file
        use masa
        use grvy
        implicit none
        integer :: i, j ! temp variable in loops
        integer :: i_row ! row number in x
        integer :: n ! num_Mesh
        real :: error = 0 ! L2 error between our solution and MASA
        integer, parameter :: fileid = 10 ! fileid for output file
        integer :: stat ! iostat

        call grvy_timer_begin('Postprocess')

        n = num_Mesh

        ! compute error between our solution and MASA
        select case(dimen)
        case(1) ! 1D

            do i = 0, n
                error = error + (x(i+1) - masa_eval_1d_exact_t(x_Coord(i)))**2
            end do
            error = error/real(n+1)
            error = sqrt(error)

        case(2) ! 2D
            
            do j = 0, n
                do i = 0, n
                    i_row = j*(n+1) + i + 1
                    error = error + (x(i_row) &
                        - masa_eval_2d_exact_t(x_Coord(i), y_Coord(j)))**2
                end do
            end do
            error = error/real((n+1)*(n+1))
            error = sqrt(error)

        case default

            stop "invalid dimension"

        end select

        ! in verification mode, output error to stdout
        if (verification_Flag == 1) then
            write(*,"('L2 error between numerical solution and MASA: ')")
            write(*,*) error
        end if

        ! write error to output file
        open(unit = fileid, file = trim(output_file), status = 'replace', &
             iostat = stat)
        if (stat /= 0) then
            print *, "unable to open", output_file
            stop
        end if
        
        write(fileid, *) n, error

        close(fileid)

        call grvy_timer_end('Postprocess')

    end subroutine Postprocess

end module Postprocess_Mod
