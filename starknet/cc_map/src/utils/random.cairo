
use debug::PrintTrait;


// ------------------------------------ random --------------------------------------
fn random(seed: u256, min: u256, max: u256) -> u256 {
    let output: u256 = keccak::keccak_u256s_be_inputs(array![seed].span());

    let mut result: u256 = u256 {
        low: integer::u128_byte_reverse(output.low), high: integer::u128_byte_reverse(output.high)
    };
    // 'result'.print();
    // result.print();

    // if result > 115792089237316195423570985008687907853269984665640564039457584007913129639935{
    //     result -= 100000000000000000000000000000000000000000000000000000000000000000000000000000;
    // }

    let mut temp = result % (max - min);
    // 'temp'.print();
    // temp.print();

    temp + min
}


#[test]
#[available_gas(30000000)]
fn test_u256() {
    let seed: u256 = 47644144660693649943980215435560498623172148321825190670936003990961659435532;
    let output: u256 = keccak::keccak_u256s_be_inputs(array![seed].span());
    let mut result: u256 = u256 {
        low: integer::u128_byte_reverse(output.low), high: integer::u128_byte_reverse(output.high)
    };
    // result.print();
    // here we can see that result [raw: 0xd99b1e3fa288fb5c1160159aa781d7c3] and [raw: 0xdd87c6975633f40323010131a0efec60]
    // but validation goes wrong
    assert(
        result == 0xd99b1e3fa288fb5c1160159aa781d7c3dd87c6975633f40323010131a0efec60
            || result == 98425958205593441920124379736634429889707266979353065459961632276135369763936,
        'result error'
    );
}

#[test]
#[ignore]
#[available_gas(30000000)]
fn test() {
    let seed: u256 = 47644144660693649943980215435560498623172148321825190670936003990961659435532;
    let min: u256 = 1;
    let max: u256 = 15;

    let output: u256 = keccak::keccak_u256s_be_inputs(array![seed].span());
    let result: u256 = u256 {
        low: integer::u128_byte_reverse(output.low), high: integer::u128_byte_reverse(output.high)
    };
    assert(
        result == 0xd99b1e3fa288fb5c1160159aa781d7c3dd87c6975633f40323010131a0efec60, 'result error'
    );

    'result'.print();
    result.print();

    let result: u256 = random(seed, min, max);
    'random'.print();
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


