! module containing control parameters for the program
module Control_Parameters_Mod
    implicit none

    integer, save :: dimen ! dimension for the problem (1 or 2)
    integer, save :: order ! order of discretization (2 or 4)
    integer, save :: solver_Flag ! solver type (1 - Jacobi, 2 - Gauss-Seidel)
    integer, save :: num_Mesh ! number of meshes in one direction
    integer, save :: verification_Flag 
        ! flag for verification mode (1 - on, 0 - off)
    integer, save :: debug_Flag ! flag for debug mode (1 - on, 0 - off)

end module Control_Parameters_Mod