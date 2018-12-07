#!/usr/bin/env bats

exec="../src/heateq"

@test "verify heateq executable exists" {
    run ls $exec
    [ "$status" -eq 0 ]
}
