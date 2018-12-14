! module defining global variables to solve Ax = b
module Solve_Common_Mod
    use Sparse_Matrix_Mod
    implicit none

    type(Sparse_Matrix_Type), save :: A
    real, allocatable, dimension(:), save :: x, b

    ! mesh coordinates
    real, allocatable, dimension(:), save :: x_Coord, y_Coord
    ! mesh size
    real, save :: h

end module Solve_Common_Mod
