use core::option::OptionTrait;
use traits::{Into, TryInto};
use array::ArrayTrait;

use debug::PrintTrait;


fn random(seed: u256, minNum: u256, maxNum: u256) -> u256 {
    keccak::keccak_u256s_be_inputs(array![seed].span()) % (maxNum - minNum) + minNum
}

fn random_(seed: u128, minNum: u128, maxNum: u128) -> u256 {
    let block_time = starknet::get_block_timestamp();
    let b_u256_time: u256 = block_time.into();
    let input = array![b_u256_time, seed.into()];
    let mut keccak_seed = keccak::keccak_u256s_be_inputs(input.span());
    return keccak_seed % (maxNum.into() - minNum.into()) + minNum.into();
}

fn random_u256(seed: u256, minNum: u256, maxNum: u256) -> u256 {
    let block_time = starknet::get_block_timestamp();
    let b_u256_time: u256 = block_time.into();
    let input = array![b_u256_time, seed];
    let mut keccak_seed = keccak::keccak_u256s_be_inputs(input.span());
    return keccak_seed % (maxNum.into() - minNum.into()) + minNum.into();
}

fn random_s(seed: felt252, minNum: u128, maxNum: u128) -> u128 {
    let t: u256 = seed.into();
    let range = maxNum - minNum;

    return (t.low % range) + minNum;
}

fn random_u128(seed: u128, min_num: u128, max_num: u128) -> u128 {
    seed % (max_num - min_num) + min_num
}

#[test]
#[available_gas(30000000)]
#[ignore]
fn test_random() {
    let mut seed = 123_u128;

    let result: u128 = random_(seed, 0_u128, 10_u128).try_into().unwrap();

    'random'.print();

    let print_result: felt252 = result.into();
    print_result.print();
    assert(result > 0, 'random normal');
}
