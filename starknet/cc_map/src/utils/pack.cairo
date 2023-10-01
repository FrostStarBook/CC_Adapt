use super::pow::get_pow;


#[derive(Copy, Drop, Serde)]
struct Pack {
    first: felt252,
    second: felt252,
    third: felt252
}

#[generate_trait]
impl PackImpl of PackTrait {
    fn new() -> Pack {
        Pack { first: 0, second: 0, third: 0, }
    }

    fn set_bit(ref self: Pack, position: u128) {
        assert(position < 625, 'invalid position');
        if position < 252 {
            self
                .first = (self.first.into() | get_pow(251 - position))
                .try_into()
                .expect('bit overflow');
        } else if position < 504 {
            self
                .second = (self.second.into() | get_pow(251 - position % 252))
                .try_into()
                .expect('bit overflow');
        } else {
            self
                .third = (self.third.into() | get_pow(251 - position % 252))
                .try_into()
                .expect('bit overflow');
        }
    }

    fn get_bit(ref self: Pack, position: u128) -> bool {
        assert(position < 625, 'invalid position');
        if position < 252 {
            self.first.into() | get_pow(251 - position) == self.first.into()
        } else if position < 504 {
            self.second.into() | get_pow(251 - position % 252) == self.second.into()
        } else {
            self.third.into() | get_pow(251 - position % 252) == self.third.into()
        }
    }

    fn add_bit(ref self: Pack, other: Pack) {
        let mut result: u256 = self.first.into() | other.first.into();
        self.first = result.try_into().expect('bit overflow');

        result = self.second.into() | other.second.into();
        self.second = result.try_into().expect('bit overflow');

        result = self.third.into() | other.third.into();
        self.third = result.try_into().expect('bit overflow');
    }

    fn subtract_bit(ref self: Pack, other: Pack) {
        let mut result: u256 = self.first.into() & ~other.first.into();
        self.first = result.try_into().expect('bit overflow');

        result = self.second.into() & ~other.second.into();
        self.second = result.try_into().expect('bit overflow');

        result = self.third.into() & ~other.third.into();
        self.third = result.try_into().expect('bit overflow');
    }

    fn count_bit(ref self: Pack) -> u128 {
        let mut count: u128 = 0;
        count_loop(self.first.into(), count)
            + count_loop(self.second.into(), count)
            + count_loop(self.third.into(), count)
    }
//
// fn delete_bit(ref sel: Pack, mut position: u128) {
//     assert(position < 625, 'invalid position');
// }

}

// const range_max: u256 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

fn count_loop(mut value: u256, mut count: u128) -> u128 {
    if value != 0 {
        value = value & (value - 1);
        count += 1;
        count_loop(value, count)
    } else {
        count
    }
}

use debug::PrintTrait;

#[test]
#[ignore]
#[available_gas(3000000)]
fn test() {
    let mut pack: Pack = Pack { first: 0, second: 0, third: 0 };
    pack.set_bit(66);
    assert(pack.get_bit(66), 'set bit');
}

fn p<T, impl TPrint: PrintTrait<T>>(t: T) {
    t.print();
}

