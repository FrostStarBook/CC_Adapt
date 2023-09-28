use core::traits::{Into, TryInto};
use debug::PrintTrait;
// use integer::u512;

#[generate_trait]
impl BitOperation of BitOperationTrait {
    fn left_shift(mut self: u256, mut count: u256) -> u256 {
        let (result, overflow) = integer::u256_overflow_mul(self, get_mod(count));
        result
    }

    fn right_shift(mut self: u256, mut count: u256) -> u256 {
        loop {
            if count == 0 || self == 0 {
                break;
            }
            self /= 2;
            count -= 1;
        };
        self
    }
}


fn get_mod(count: u256) -> u256 {
    if count < 30 {
        if count < 15 {
            if count < 7 {
                if count == 1 {
                    1
                } else if count == 2 {
                    4
                } else if count == 3 {
                    8
                } else if count == 4 {
                    16
                } else if count == 5 {
                    32
                } else {
                    64
                }
            } else {
                if count == 7 {
                    128
                } else if count == 8 {
                    256
                } else if count == 9 {
                    512
                } else if count == 10 {
                    1024
                } else if count == 11 {
                    2048
                } else if count == 12 {
                    4096
                } else if count == 13 {
                    8192
                } else if count == 14 {
                    16384
                } else {
                    32768
                }
            }
        } else {
            if count < 23 {
                if count == 16 {
                    65536
                } else if count == 17 {
                    131072
                } else if count == 18 {
                    262144
                } else if count == 19 {
                    524288
                } else if count == 20 {
                    1048576
                } else if count == 21 {
                    2097152
                } else {
                    4194304
                }
            } else {
                if count == 23 {
                    8388608
                } else if count == 24 {
                    16777216
                } else if count == 25 {
                    33554432
                } else if count == 26 {
                    67108864
                } else if count == 27 {
                    134217728
                } else if count == 28 {
                    268435456
                } else if count == 29 {
                    536870912
                } else {
                    1073741824
                }
            }
        }
    } else {
        if count < 45 {
            if count < 40 {
                if count == 31 {
                    2147483648
                } else if count == 32 {
                    4294967296
                } else if count == 33 {
                    8589934592
                } else if count == 34 {
                    17179869184
                } else if count == 35 {
                    34359738368
                } else if count == 36 {
                    68719476736
                } else if count == 37 {
                    137438953472
                } else if count == 38 {
                    274877906944
                } else {
                    549755813888
                }
            } else {
                if count == 40 {
                    1099511627776
                } else if count == 41 {
                    2199023255552
                } else if count == 42 {
                    4398046511104
                } else if count == 43 {
                    8796093022208
                } else if count == 44 {
                    17592186044416
                } else {
                    35184372088832
                }
            }
        } else {
            if count == 46 {
                70368744177664
            } else if count == 47 {
                140737488355328
            } else if count == 48 {
                281474976710656
            } else if count == 49 {
                562949953421312
            } else if count == 50 {
                1125899906842624
            } else if count == 51 {
                2251799813685248
            } else if count == 52 {
                4503599627370496
            } else if count == 53 {
                9007199254740992
            } else if count == 54 {
                18014398509481984
            } else if count == 55 {
                36028797018963968
            } else if count == 56 {
                72057594037927936
            } else if count == 57 {
                144115188075855872
            } else if count == 58 {
                288230376151711744
            } else if count == 59 {
                576460752303423488
            } else {
                1152921504606846976
            }
        }
    }
}

// Libfunc print is not allowed in the libfuncs list

// #[test]
// #[ignore]
// #[available_gas(3000000000000)]
// fn test1() {
//     let i: u256 = 104616311173140485099082100255315365365044651156030064548209934585479422322683;
//     let mut count = 0;
//     loop {
//         if count > 1000 {
//             break;
//         }
//         (i.left_shift(count)).print();
//         count += 1;
//     }
// }

#[test]
#[available_gas(300000000000000000)]
fn test() {
    let a: u256 = 1;
    let b: u256 = 32;
    let mut result: u256 = a.left_shift(b);
    assert(result == 4294967296, 'left shift over');

    let c: u256 = 128;
    let d: u256 = 3;
    result = c.right_shift(d);
    assert(result == 16, 'right shift over');

    let n = 104616311173140485099082100255315365365044651156030064548209934585479422322683;
    let rr = n.right_shift(10);
    let gg = n / 1024;

    rr.print();
    gg.print();

    assert(rr == gg, 'sss');
}

