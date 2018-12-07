#!/usr/bin/env bats

exec="../src/heateq"

@test "verify heateq results for 1D 2nd-order problem with Jacobi method" {
    run $exec input_1D_order2_J.dat
    [ "$status" -eq 0 ]
    run diff sol.dat ref_1D_order2_J.dat
    [ "$status" -eq 0 ]
}
