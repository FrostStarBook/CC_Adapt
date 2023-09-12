use core::traits::{Into, TryInto};

fn left_shift(base: u128, count: u128) -> u128 {
    let mut result: u128 = 1;

    let mut loop_count = count;
    loop {
        if count == 0 {
            break;
        }

        result *= 2;

        loop_count -= 1;
    };

    result *= base;
    assert(result > base, 'over shift');

    result
}

fn right_shift(base: u128, count: u128) -> u128 {
    let mut result: u128 = 1;

    let mut loop_count = count;
    loop {
        if count == 0 {
            break;
        }

        result /= 2;

        loop_count -= 1;
    };

    result /= base;
    assert(result < base, 'over shift');

    result
}

// fn get_devided(base: u128, count: u128) -> (u128, u128) {


// }
