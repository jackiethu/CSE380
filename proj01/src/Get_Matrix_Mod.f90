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
        
        ! second to nth row (n is num_Mesh, A has n+1 rows in total)
        do i = 2, A%n - 1
            indices_3(1) = i - 1
            indices_3(2) = i
            indices_3(3) = i + 1
            call A%row(i)%Init(3, indices_3, values_3)
        end do

        ! (n+1)th row
        indices_1 = A%n
        call A%row(A%n)%Init(1, indices_1, values_1)
    
    end subroutine Get_Matrix_1D_Order2

!    subroutine Get_Matrix_2D
!
!    end subroutine Get_Matrix_2D

end module Get_Matrix_Mod
