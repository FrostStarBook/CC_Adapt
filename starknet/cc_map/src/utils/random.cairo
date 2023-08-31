use traits::{Into, TryInto};
use array::ArrayTrait;


fn random(seed: u128, minNum: u128, maxNum: u128) -> u256 {
    let block_time = starknet::get_block_timestamp();
    let b_u256_time: u256 = block_time.into();
    let input = array![b_u256_time, seed.into()];
    let mut keccak_seed = keccak::keccak_u256s_be_inputs(input.span());
    return keccak_seed % (maxNum.into() - minNum.into()) + minNum.into();
}

fn random_s(seed: felt252, minNum: u128, maxNum: u128) -> u128 {
    let t: u256 = seed.into();
    let range = maxNum - minNum;

    return (t.low % range) + minNum;
}

#[test]
#[available_gas(30000000)]
fn test_random() {
    let mut seed = 123_u128;

    let result = random(seed, 0_u128, 10_u128);
    assert(result > 0, 'random normal');

}
