use debug::PrintTrait;

// ------------------------------------ random --------------------------------------
fn random(seed: u256, min: u256, max: u256) -> u256 {
    let output: u256 = keccak::keccak_u256s_be_inputs(array![seed].span());

    (u256 {
        low: integer::u128_byte_reverse(output.high), // just for format here
        high: integer::u128_byte_reverse(output.low)
    }) % (max - min)
        + min
}


#[test]
#[available_gas(30000000)]
fn test() {
    let seed: u256 = 47644144660693649943980215435560498623172148321825190670936003990961659435532;
    let min: u256 = 1;
    let max: u256 = 15;

    let result = random(seed, min, max);
    result.print();

    assert(result == 9, 'random');
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


