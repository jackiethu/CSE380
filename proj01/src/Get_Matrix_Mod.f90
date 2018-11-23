! module to define matrix A for Ax = b
module Get_Matrix_Mod
    implicit none

contains
    
    subroutine Get_Matrix_1D_Order2
        ! output: A for 1D problem with 2nd order finite difference

        use Solve_Common_Mod, only : A 
        implicit none
        integer, dimension(1) :: indices_1 ! used to store one-term index
        integer, dimension(3) :: indices_3 ! used to store 3-term indices
        real, dimension(1) :: values_1 = [1.0]
        real, dimension(3) :: values_3 = [1.0, -2.0, 1.0]
        integer :: i 
        
        if (.not. allocated(A%row)) stop "A%row not allocated"
        ! first row
        indices_1 = 1
        call A%row(1)%Init(1, indices_1, values_1)
        
        ! second to (n-1)th row (A has n rows in total)
        do i = 2, A%n - 1
            indices_3(1) = i - 1
            indices_3(2) = i
            indices_3(3) = i + 1
            call A%row(i)%Init(3, indices_3, values_3)
        end do

        ! nth row
        indices_1 = A%n
        call A%row(A%n)%Init(1, indices_1, values_1)
    
    end subroutine Get_Matrix_1D_Order2


    subroutine Get_Matrix_1D_Order4
        ! output: A for 1D problem with 4th order finite difference

        use Solve_Common_Mod, only : A
        implicit none
        integer, dimension(1) :: indices_1 ! 1 term index
        integer, dimension(3) :: indices_3 ! 3-term indices
        integer, dimension(5) :: indices_5 ! 5-term indices
        real, dimension(1) :: values_1 = [1.0]
        real, dimension(3) :: values_3 = [1.0, -2.0, 1.0]
        real, dimension(5) :: values_5 = [-1.0/12.0, 4.0/3.0, -5.0/2.0, &
                                            4.0/3.0, -1.0/12.0]
        integer :: i
        integer :: n ! A is an n*n matrix
        
        n = A%n
        if (n <= 4) stop "mesh number is too small to apply 4th order scheme"
        if (.not. allocated(A%row)) stop "A%row not allocated"

        ! first row & last row
        indices_1 = 1
        call A%row(1)%Init(1, indices_1, values_1)
        indices_1 = n
        call A%row(n)%Init(1, indices_1, values_1)

        ! 2nd row & (n-1)th row
        indices_3 = [1, 2, 3]
        call A%row(2)%Init(3, indices_3, values_3)
        indices_3 = [n-2, n-1, n]
        call A%row(n-1)%Init(3, indices_3, values_3)

        ! 3rd to (n-2)th row
        do i = 3, n-2
            indices_5 = [i-2, i-1, i, i+1, i+2]
            call A%row(i)%Init(5, indices_5, values_5)
        end do
    
    end subroutine Get_Matrix_1D_Order4


    subroutine Get_Matrix_2D_Order2
        ! output: A for 2D problem with 2nd order finite difference

        use Solve_Common_Mod, only : A
        implicit none
        integer, dimension(1) :: indices_1 ! one-term index
        integer, dimension(5) :: indices_5 ! five-term index
        real, dimension(1) :: values_1 = [1.0]
        real, dimension(5) :: values_5 = [1.0, 1.0, -4.0, 1.0, 1.0]

        integer :: i, i_block
        integer :: i_row ! temporary variable to store current row number
        integer :: n ! n is the number of grid points in each direction

        n = nint( sqrt( real(A%n) ) ) ! A is an n^2 * n^2 matrix

        if (.not. allocated(A%row)) stop "A%row not allocated"

        ! first block
        do i = 1, n
            indices_1 = i
            call A%row(i)%Init(1, indices_1, values_1)
        end do

        ! last block
        do i = n*n-n+1, n*n
            indices_1 = i
            call A%row(i)%Init(1, indices_1, values_1)
        end do

        ! 2nd block to (n-1)th block
        do i_block = 2, n-1

            ! first line in the block
            i_row = n*(i_block-1) + 1
            indices_1 = i_row
            call A%row(i_row)%Init(1, indices_1, values_1)

            ! last line in the block
            i_row = n*(i_block-1) + n
            indices_1 = i_row
            call A%row(i_row)%Init(1, indices_1, values_1)

            ! 2nd to (n-1)th line in the block
            do i = 2, n-1
                i_row = n*(i_block-1) + i
                indices_5 = [i_row-n, i_row-1, i_row, i_row+1, i_row+n]
                call A%row(i_row)%Init(5, indices_5, values_5)
            end do

        end do

    end subroutine Get_Matrix_2D_Order2


    subroutine Get_Matrix_2D_Order4

    end subroutine Get_Matrix_2D_Order4

end module Get_Matrix_Mod
