use core::traits::{Into, TryInto};
use debug::PrintTrait;


#[generate_trait]
impl BitOperation of BitOperationTrait {
    fn left_shift(self: u256, mut count: u256) -> u256 {
        let mut result: u256 = 1;
        loop {
            if count == 0 {
                break;
            }
            result *= 2;
            count -= 1;
        };
        result *= self;
        assert(result >= self, 'over shift in left shift');
        result
    }

    fn right_shift(self: u256, mut count: u256) -> u256 {
        let mut result: u256 = 1;
        loop {
            if count == 0 {
                break;
            }
            result *= 2;
            count -= 1;
        };
        result = self / result;
        assert(result <= self, 'over shift in right shift');
        result
    }
}

#[test]
#[available_gas(30000000)]
fn test() {
    let a: u256 = 1;
    let b: u256 = 32;
    let mut result: u256 = a.left_shift(b);
    assert(result == 4294967296, 'left shift over');

    let c: u256 = 128;
    let d: u256 = 3;
    result = c.right_shift(d);
    assert(result == 16, 'right shift over');
}
