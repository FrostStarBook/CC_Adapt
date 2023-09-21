use core::traits::{Into, TryInto};
use debug::PrintTrait;

use integer::u512;

#[generate_trait]
impl BitOperation of BitOperationTrait {
    fn left_shift(mut self: u256, mut count: u256) -> u256 {
        loop {
            if count == 0 {
                break;
            }
            // overflow 2^255
            if self >= 57896044618658097711785492504343953926634992332820282019728792003956564819968 {
                self =
                    (self
                        - 57896044618658097711785492504343953926634992332820282019728792003956564819968)
                    * 2;
            } else {
                self *= 2;
            }

            count -= 1;
        };

        self
    }

    fn right_shift(mut self: u256, mut count: u256) -> u256 {
        loop {
            if count == 0 {
                break;
            }
            self /= 2;
            count -= 1;
        };
        self
    }
}


#[test]
#[ignore]
#[available_gas(3000000000000)]
fn test1() {
    let i: u256 = 104616311173140485099082100255315365365044651156030064548209934585479422322683;
    let mut count = 0;
    loop {
        if count > 1000 {
            break;
        }
        (i.left_shift(count)).print();
        count += 1;
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
