use core::option::OptionTrait;
use traits::{Into, TryInto};
use array::ArrayTrait;

use debug::PrintTrait;


// ------------------------------------ random --------------------------------------
fn random(seed: u256, minNum: u256, maxNum: u256) -> u256 {
    let output: u256 = keccak::keccak_u256s_be_inputs(array![seed].span()) % (maxNum - minNum)
        + minNum;
    u256 {
        low: integer::u128_byte_reverse(output.low), high: integer::u128_byte_reverse(output.high)
    }
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
fn test() {
    let seed: u256 = 13775942172093573085967568754928963453267290232609549077015257496415683079456;
    let min: u256 = 0;
    let max: u256 = 100;

    let result: u256 = random(seed, 0, 100);
    'random'.print();
    result.print();

    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, seed);

    let result = keccak_input.span();
    let mut count = 0;
    loop {
        if count == result.len() {
            break;
        }
        let iii = *result[count];
        iii.print();
        count += 1;
    };
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


