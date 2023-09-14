use core::traits::{Into, TryInto};
use debug::PrintTrait;


#[generate_trait]
impl BitOperation of BitOperationTrait {
    fn left_shift(self: u128, count: u128) -> u128 {
        let mut result: u128 = 1;
        let mut loop_count = count;
        loop {
            if loop_count == 0 {
                break;
            }
            result *= 2;
            loop_count -= 1;
        };
        result *= self;
        assert(result > self, 'over shift');
        result
    }

    fn right_shift(self: u128, count: u128) -> u128 {
        let mut result: u128 = 1;
        let mut loop_count = count;
        loop {
            if loop_count == 0 {
                break;
            }
            result *= 2;
            loop_count -= 1;
        };
        result = self / result;
        assert(result < self, 'over shift');
        result
    }
}

#[test]
#[available_gas(30000000)]
fn test() {

    let a: u128 = 1;
    let b: u128 = 32;
    let mut result: u128 = a.left_shift(b);
    assert(result == 4294967296, 'left shift over');

    let c: u128 = 128;
    let d: u128 = 3;
    result = c.right_shift(d);
    assert(result == 16, 'right shift over');

}
