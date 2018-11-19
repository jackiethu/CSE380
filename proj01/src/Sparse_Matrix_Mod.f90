! module defining sparse matrix, initializing functions,
!     and a subroutine to output sparse matrix
module Sparse_Matrix_Mod
    implicit none

    type :: Sparse_Row_Type
        integer :: num_Nonzero ! number of nonzero entries
        integer, allocatable :: indices(:) ! colomn indices for nonzero entries
        real, allocatable :: values(:) ! nonzero values
        contains
            procedure :: Init => Init_Row
    end type Sparse_Row_Type

    type :: Sparse_Matrix_Type ! only support square matrix
        integer :: n ! the dimension of the matrix is n*n
        type(Sparse_Row_Type), allocatable :: row(:)
        contains
            procedure :: Init => Init_Matrix
            procedure :: Print_Matrix
    end type Sparse_Matrix_Type

contains

    subroutine Init_Row(this, num_Nonzero, indices, values)
        implicit none
        class(Sparse_Row_Type), intent(out) :: this
        integer, intent(in) :: num_Nonzero
        integer, intent(in) :: indices(num_Nonzero)
        real, intent(in) :: values(num_Nonzero)
        integer :: ierr ! indicator for error

        this%num_Nonzero = num_Nonzero
        allocate( this%indices(num_Nonzero), stat = ierr )
        if (ierr /= 0) stop "Allocation error: Init_Row"
        allocate( this%values(num_Nonzero), stat = ierr )
        if (ierr /= 0) stop "Allocation error: Init_Row"
        this%indices = indices
        this%values = values
    end subroutine Init_Row

    subroutine Init_Matrix(this, n)
        implicit none
        class(Sparse_Matrix_Type), intent(out) :: this
        integer, intent(in) :: n
        integer :: ierr ! error indicator

        this%n = n
        allocate( this%row(n), stat = ierr )
        if (ierr /= 0) stop "Allocation error: Init_Matrix"
    end subroutine Init_Matrix

    subroutine Print_Matrix(this)
        implicit none
        class(Sparse_Matrix_Type), intent(in) :: this
        integer :: i, j, k
        do i = 1, this%n ! loop through rows of matrix
            do k = 1, this%row(i)%num_Nonzero
                j = this%row(i)%indices(k)
                write(*,"('(', I3, ',', I3, '):', F6.1)") &
                    i, j, this%row(i)%values(k)
            end do
        end do
    end subroutine Print_Matrix

end module Sparse_Matrix_Mod


!program test
!    use Jacobi_GS_Mod
!    implicit none
!
!    type(Sparse_Matrix_Type) :: mat
!    integer :: i
!    integer :: indices1(2) = [1, 2], indices2(1) = 1
!    real :: values1(2) = [1.2, 2.5], values2(1) = 3.6
!    
!    call mat%Init(2)
!    call mat%row(1)%Init(2, indices1, values1)
!    call mat%row(2)%Init(1, indices2, values2)
!    do i = 1, 2
!        print *, "row", i
!        print *, "num_Nonzero: ", mat%row(i)%num_Nonzero
!        print *, "indices: ", mat%row(i)%indices
!        print *, "values: ", mat%row(i)%values
!        print *
!    end do
!
!end program test
