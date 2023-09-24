use debug::PrintTrait;

// ------------------------------------ random --------------------------------------

fn random(seed: u256, min: u256, max: u256) -> u256 {
    let output: u256 = keccak::keccak_u256s_be_inputs(array![seed].span());

    (u256 {
        low: integer::u128_byte_reverse(output.high), // just comment here to
        high: integer::u128_byte_reverse(output.low) //  avoid stupid format
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
    assert(result == 9, 'random');
}



