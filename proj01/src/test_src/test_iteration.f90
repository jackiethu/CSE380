program test ! test Jacobi & GS  method (cp. Wikipedia Example)
    use Jacobi_GS_Mod
    implicit none

    type(Sparse_Matrix_Type) :: A
    integer, dimension(2) :: index = [1, 2]
    real, dimension(2)    :: row1 = [16.0, 3.0]
    real, dimension(2)    :: row2 = [7.0, -11.0]
    real, dimension(2)    :: x0 = [1.0, 1.0]
    real, dimension(2)    :: b = [11.0, 13.0]
    real, dimension(2)    :: x
    integer               :: i

    ! initialize matrix
    call A%Init(2)
    call A%row(1)%Init(2, index, row1)
    call A%row(2)%Init(2, index, row2)

    ! iteration
    x = x0
    !x = Update_Jacobi(A, x, b)
    !print *, x(1), x(2)

    !x = Update_Jacobi(A, x, b)
    !print *, x(1), x(2)
    do i = 1, 7 
        x = Update_GS(A, x, b)
        print *, x(1), x(2)
    end do

end program test
