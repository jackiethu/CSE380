#!/usr/bin/env bats

exec="../src/heateq"

@test "verify heateq results for 2D 2nd-order problem with G-S method" {
    run $exec input_2D_order4_GS.dat
    [ "$status" -eq 0 ]
    run diff sol.dat ref_2D_order4_GS.dat
    [ "$status" -eq 0 ]
}
