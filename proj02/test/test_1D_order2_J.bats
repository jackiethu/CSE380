#!/usr/bin/env bats

exec="../src/heateq"

@test "verify heateq results for 1D 2nd-order problem with Jacobi method" {
    run $exec input_1D_order2_J.dat
    [ "$status" -eq 0 ]
    run h5diff -d 1e-12 sol.h5 ref_1D_order2_J.h5 /dset_t
    [ "$status" -eq 0 ]
}
