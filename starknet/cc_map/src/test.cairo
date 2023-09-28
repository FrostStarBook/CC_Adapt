#[cfg(test)]
mod tests {
    use debug::PrintTrait;
    use bytes_31::{bytes31, one_shift_left_bytes_felt252, one_shift_left_bytes_u128};
    use integer::{u256_overflow_mul};

    fn pow_two(exponent: u256) -> u256 {
        let exponent = exponent % 256;
        if exponent == 1 {
            0x2
        } else if exponent == 10 {
            0x400
        } else if exponent == 252 {
            0x1000000000000000000000000000000000000000000000000000000000000000
        } else if exponent == 248 {
            0x100000000000000000000000000000000000000000000000000000000000000
        } else if exponent == 256 {
            0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        } else {
            panic_with_felt252('exponent too big')
        }
    }

    // #[test]
    // #[available_gas(1000000000)]
    // fn it_works() {
    //     let seed: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    //     // let rand = seed << 248;
    //     //let rand = seed * pow_two(248);//will overflow
    //     let (rand, overflow) = u256_overflow_mul(seed, pow_two(248));
    //     rand.print();
    //     overflow.print();
    // }
}
