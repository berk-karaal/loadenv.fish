source functions/loadenv.fish

function test_unload_option

    if not loadenv tests/unload.env
        echo "Failed to run loadenv function to export variables."
        return 1
    end

    # Check if all variables are loaded correctly
    if not set -q TEST_KEY_1; or test $TEST_KEY_1 != value1
        echo "TEST_KEY_1 was not loaded correctly."
        return 1
    end
    if not set -q TEST_KEY_2; or test $TEST_KEY_2 != value2
        echo "TEST_KEY_2 was not loaded correctly."
        return 1
    end
    if not set -q TEST_KEY_3; or test $TEST_KEY_3 != value3
        echo "TEST_KEY_3 was not loaded correctly."
        return 1
    end

    if not loadenv -U tests/unload.env
        echo "Failed to run loadenv function to unload variables."
        return 1
    end

    # Check if all variables are unloaded
    if set -q TEST_KEY_1
        echo "TEST_KEY_1 was not unloaded"
        return 1
    end
    if set -q TEST_KEY_2
        echo "TEST_KEY_2 was not unloaded"
        return 1
    end
    if set -q TEST_KEY_3
        echo "TEST_KEY_3 was not unloaded"
        return 1
    end

    return 0
end

test_unload_option
@test "test unload option" $status = 0
