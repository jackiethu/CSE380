! module to postprocess: compute error norm and output
module Postprocess_Mod
    implicit none
contains

    subroutine Postprocess
        use Solve_Common_Mod, only : x, x_Coord, y_Coord
        use Control_Parameters_Mod, only : dimen, num_Mesh, verification_Flag
        use masa
        use grvy
        implicit none
        integer :: i, j ! temp variable in loops
        integer :: i_row ! row number in x
        integer :: n ! num_Mesh
        real :: error = 0 ! L2 error between our solution and MASA
        !integer, parameter :: fileid = 10 ! fileid for output file
        !integer :: stat ! iostat

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

!        ! write solution to output file
!        open(unit = fileid, file = trim(output_file), status = 'replace', &
!             iostat = stat)
!        if (stat /= 0) then
!            print *, "unable to open", output_file
!            stop
!        end if
!        
!        do i = 1, size(x)
!            write(fileid, "(E13.6)") x(i)
!        end do
!
!        close(fileid)

        ! write solution to hdf5 file
        call Output_hdf5

        call grvy_timer_end('Postprocess')

    end subroutine Postprocess

    subroutine Output_hdf5
    ! subroutine to write solution data to hdf5 file
        use Solve_Common_Mod, only : x, x_Coord, y_Coord
        use Control_Parameters_Mod, only : dimen, num_Mesh, output_file
        use masa
        use hdf5

        implicit none

        ! dataset name for x, y coordinates and temperature field
        character(len=*), parameter :: dset_x_name = "dset_x"
        character(len=*), parameter :: dset_y_name = "dset_y"
        character(len=*), parameter :: dset_t_name = "dset_t"
        character(len=*), parameter :: dset_texact_name = "dset_texact"
        
        integer(HID_T) :: file_id       ! File identifier
        integer(HID_T) :: dset_x_id       ! Dataset x identifier
        integer(HID_T) :: dset_y_id       ! Dataset y identifier  
        integer(HID_T) :: dset_t_id       ! Dataset t identifier  
        integer(HID_T) :: dset_texact_id  ! Dataset texact identifier  
        integer(HID_T) :: dspace_1D_id ! dataspace identifier for 1D data
        integer(HID_T) :: dspace_2D_id ! dataspace identifier for 2D data

        integer(HSIZE_T), dimension(1) :: dim_1D ! 1D dataset dimensions
        integer(HSIZE_T), dimension(2) :: dim_2D ! 1D dataset dimensions
        integer :: n ! n = num_Mesh

        integer :: hdferr ! error flag for hdf5 procedures

        ! allocatable array to store exact temperature field
        real, dimension(:), allocatable   :: t_exact_1D
        real, dimension(:,:), allocatable :: t_exact_2D
        integer :: ierr ! error indicator for memory allocation
        integer :: i, j ! array indices

        n = num_Mesh

        ! get exact temperature field from MASA
        select case(dimen)
        case(1)
            allocate( t_exact_1D(0:n), stat = ierr )
            if (ierr /= 0) stop "unable to allocate t_exact_1D"
            do i = 0, n
                t_exact_1D(i) = masa_eval_1d_exact_t(x_Coord(i))
            end do
        case(2)
            allocate( t_exact_2D(0:n, 0:n), stat = ierr )
            if (ierr /= 0) stop "unable to allocate t_exact_2D"
            do j = 0, n
                do i = 0, n
                    t_exact_2D(i, j) = masa_eval_2d_exact_t(x_Coord(i), &
                        y_Coord(j))
                end do
            end do
        end select

        ! initialize Fortran interface
        call h5open_f(hdferr)

        ! create a new file using default properties
        call h5fcreate_f(output_file, H5F_ACC_TRUNC_F, file_id, hdferr)

        ! create the dataspaces
        dim_1D = n+1
        dim_2D = [n+1, n+1]
        call h5screate_simple_f(1, dim_1D, dspace_1D_id, hdferr)
        call h5screate_simple_f(2, dim_2D, dspace_2D_id, hdferr)

        ! create the datasets with default properties
        call h5dcreate_f(file_id, dset_x_name, H5T_NATIVE_DOUBLE, dspace_1D_id,&
            dset_x_id, hdferr)
        if (dimen == 2) then
            call h5dcreate_f(file_id, dset_y_name, H5T_NATIVE_DOUBLE, dspace_1D_id,&
                dset_y_id, hdferr)
        end if
        select case(dimen)
        case(1) ! 1D
            call h5dcreate_f(file_id, dset_t_name, H5T_NATIVE_DOUBLE, &
               dspace_1D_id, dset_t_id, hdferr) 
            call h5dcreate_f(file_id, dset_texact_name, H5T_NATIVE_DOUBLE, &
               dspace_1D_id, dset_texact_id, hdferr) 
        case(2) ! 2D
            call h5dcreate_f(file_id, dset_t_name, H5T_NATIVE_DOUBLE, &
               dspace_2D_id, dset_t_id, hdferr) 
            call h5dcreate_f(file_id, dset_texact_name, H5T_NATIVE_DOUBLE, &
               dspace_2D_id, dset_texact_id, hdferr) 
        end select
        
        !
        ! write solution data to datasets
        !
        ! write coordinates
        call h5dwrite_f(dset_x_id, H5T_NATIVE_DOUBLE, x_Coord, dim_1D, hdferr)
        if (dimen == 2) then
            call h5dwrite_f(dset_y_id, H5T_NATIVE_DOUBLE, y_Coord, dim_1D, hdferr)
        end if
        ! write numerical & analytic temperature field
        select case(dimen)
        case(1)
            call h5dwrite_f(dset_t_id, H5T_NATIVE_DOUBLE, x, dim_1D, hdferr)
            call h5dwrite_f(dset_texact_id, H5T_NATIVE_DOUBLE, t_exact_1D, &
                dim_1D, hdferr)
        case(2)
            call h5dwrite_f(dset_t_id, H5T_NATIVE_DOUBLE, &
                reshape(x, [n+1,n+1]), dim_2D, hdferr)
            call h5dwrite_f(dset_texact_id, H5T_NATIVE_DOUBLE, t_exact_2D, &
                dim_2D, hdferr)
        end select
        
        ! end access to the datasets and release resources used by it
        call h5dclose_f(dset_x_id, hdferr)
        if (dimen == 2) then
            call h5dclose_f(dset_y_id, hdferr)
        end if
        call h5dclose_f(dset_t_id, hdferr)
        call h5dclose_f(dset_texact_id, hdferr)

        ! terminate access to the dataspaces
        call h5sclose_f(dspace_1D_id, hdferr)
        call h5sclose_f(dspace_2D_id, hdferr)

        ! close the file
        call h5fclose_f(file_id, hdferr)

        ! close Fortran interface
        call h5close_f(hdferr)

    end subroutine Output_hdf5

end module Postprocess_Mod
