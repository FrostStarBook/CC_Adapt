use core::traits::{Into, TryInto};



#[generate_trait]
impl BitOperation of BitOperationTrait {
    fn left_shift(self: u128, count: u128) -> u128 {
        let mut result: u128 = 1;

        let mut loop_count = count;
        loop {
            if count == 0 {
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
            if count == 0 {
                break;
            }

            result /= 2;

            loop_count -= 1;
        };

        result /= self;
        assert(result < self, 'over shift');

        result
    }
}
