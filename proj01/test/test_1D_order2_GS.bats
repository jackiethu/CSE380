#!/usr/bin/env bats

exec="../src/heateq"

@test "verify heateq results for 1D 2nd-order problem with G-S method" {
    run $exec input_1D_order2_GS.dat
    [ "$status" -eq 0 ]
    run diff sol.dat ref_1D_order2_GS.dat
    [ "$status" -eq 0 ]
}
