#!/usr/bin/env bats

exec="../src/heateq"

@test "verify heateq results for 1D 4th-order problem with G-S method" {
    run $exec input_1D_order4_GS.dat
    [ "$status" -eq 0 ]
    run diff sol.dat ref_1D_order4_GS.dat
    [ "$status" -eq 0 ]
}
