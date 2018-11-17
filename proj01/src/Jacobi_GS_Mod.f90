! module defining update scheme for Jacobi and GS iteration
module Jacobi_GS_Mod
    use Sparse_Matrix_Mod
    implicit none

contains
    
    function Update_Jacobi(A, x, b) result(x_New)
    ! compute one interative step with Jacobi method
        implicit none
        real, dimension(:), intent(in)       :: x
        real, dimension(size(x))             :: x_New
        real, dimension(:), intent(in)       :: b
        type(Sparse_Matrix_Type), intent(in) :: A 

        integer :: i, j, k ! used for indexing matrix elements
        real    :: sum  ! temp variable to store sum of A(i,j)*x(j)
        type(Sparse_Row_Type) :: row
        real    :: A_ii ! temp variable to store A(i,i)

        do i = 1, size(x)
            row = A%row(i)
            sum = 0.0
            do k = 1, row%num_Nonzero
                j = row%indices(k)
                if (j == i) then
                    A_ii = row%values(k)
                    cycle
                end if
                sum = sum + row%values(k)*x(j)
            end do
            x_New(i) = ( b(i) - sum ) / A_ii
        end do

    end function Update_Jacobi


    function Update_GS(A, x, b) result(x_New)
    ! compute one interative step with Gauss-Seidel method
        implicit none
        real, dimension(:), intent(in)       :: x
        real, dimension(size(x))             :: x_New
        real, dimension(:), intent(in)       :: b
        type(Sparse_Matrix_Type), intent(in) :: A 

        integer :: i, j, k ! used for indexing matrix elements
        real    :: sum  ! temp variable to store sum of A(i,j)*x(j)
        type(Sparse_Row_Type) :: row
        real    :: A_ii ! temp variable to store A(i,i)

        do i = 1, size(x)
            row = A%row(i)
            sum = 0.0
            do k = 1, row%num_Nonzero
                j = row%indices(k)
                if (j < i) then
                    sum = sum + row%values(k)*x_New(j)
                else if (j == i) then
                    A_ii = row%values(k)
                else
                    sum = sum + row%values(k)*x(j)
                end if
            end do
            x_New(i) = ( b(i) - sum ) / A_ii
        end do

    end function Update_GS

end module Jacobi_GS_Mod
