use core::option::OptionTrait;
use traits::{Into, TryInto};
use array::ArrayTrait;

use debug::PrintTrait;


// ------------------------------------ random --------------------------------------
fn random(seed: u256, min: u256, max: u256) -> u256 {
    let output: u256 = keccak::keccak_u256s_be_inputs(array![seed].span());

    let result: u256 = u256 {
        low: integer::u128_byte_reverse(output.low), high: integer::u128_byte_reverse(output.high)
    };

    let mut mode: u256 = max - min;
    'mode'.print();
    mode.print();

    // let (_, remainder) = integer::u256_safe_div_rem(result, integer::u256_as_non_zero(mode));
    let remainder = calculate_remainder(result, mode);
    'remainder'.print();
    remainder.print();

    remainder + min
}

fn calculate_remainder(dividend: u256, divisor: u256) -> u256 {
    assert(divisor != 0, 'Divisor cannot be zero.');

    let quotient = dividend / divisor;
    let product = quotient * divisor;
    let remainder = dividend - product;

    remainder
}

fn random_origin(seed: u256) -> u256 {
    keccak::keccak_u256s_be_inputs(array![seed].span())
}


// ------------------------------------ test only --------------------------------------
fn u128_split(input: u128) -> (u64, u64) {
    let (high, low) = integer::u128_safe_divmod(
        input, 0x10000000000000000_u128.try_into().unwrap()
    );

    (u128_to_u64(high), u128_to_u64(low))
}

fn u128_to_u64(input: u128) -> u64 {
    input.try_into().unwrap()
}

fn keccak_add_u256_be(ref keccak_input: Array::<u64>, v: u256) {
    let (high, low) = u128_split(integer::u128_byte_reverse(v.high));
    keccak_input.append(low);
    keccak_input.append(high);
    let (high, low) = u128_split(integer::u128_byte_reverse(v.low));
    keccak_input.append(low);
    keccak_input.append(high);
}


#[test]
#[available_gas(30000000)]
fn test2() {
    let origin: u256 = 98425958205593441920124379736634429889707266979353065459961632276135369763936;
    'mod'.print();
    (origin % 14).print();
}

#[test]
#[ignore]
#[available_gas(30000000)]
fn test() {
    let seed: u256 = 47644144660693649943980215435560498623172148321825190670936003990961659435532;
    // 'seed'.print();
    // seed.print();
    let min: u256 = 1;
    let max: u256 = 15;

    let result: u256 = random(seed, min, max);
    'random'.print();
    result.print();
    assert(result == 9, 'random');

    {}

    // let high: u128 = integer::u128_byte_reverse(result.high);
    // 'high'.print();
    // high.print();
    // let low: u128 = integer::u128_byte_reverse(result.low);
    // 'low'.print();
    // low.print();

    // let final: u256 = u256 { low: low, high: high };
    // 'final'.print();
    // final.print();

    {}
// let mut keccak_input: Array::<u64> = Default::default();
// keccak_add_u256_be(ref keccak_input, seed);

// let result = keccak_input.span();
// let mut count = 0;
// loop {
//     if count == result.len() {
//         break;
//     }
//     let iii = *result[count];
//     iii.print();
//     count += 1;
// };
}
// ------------------------------------- not used --------------------------------------
//
//
//
//
// fn random_(seed: u128, minNum: u128, maxNum: u128) -> u256 {
//     let block_time = starknet::get_block_timestamp();
//     let b_u256_time: u256 = block_time.into();
//     let input = array![b_u256_time, seed.into()];
//     let mut keccak_seed = keccak::keccak_u256s_be_inputs(input.span());
//     return keccak_seed % (maxNum.into() - minNum.into()) + minNum.into();
// }

// fn random_u256(seed: u256, minNum: u256, maxNum: u256) -> u256 {
//     let block_time = starknet::get_block_timestamp();
//     let b_u256_time: u256 = block_time.into();
//     let input = array![b_u256_time, seed];
//     let mut keccak_seed = keccak::keccak_u256s_be_inputs(input.span());
//     return keccak_seed % (maxNum.into() - minNum.into()) + minNum.into();
// }
// #[test]
// #[available_gas(30000000)]
// #[ignore]
// fn test_random() {
//     let mut seed = 123_u128;

//     let result: u128 = random_(seed, 0_u128, 10_u128).try_into().unwrap();

//     'random'.print();

//     let print_result: felt252 = result.into();
//     print_result.print();
//     assert(result > 0, 'random normal');
// }


