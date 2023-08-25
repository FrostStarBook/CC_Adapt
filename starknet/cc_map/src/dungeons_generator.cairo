#[starknet::contract]
mod DungeonsGenerator {
    use array::ArrayTrait;
    use debug::PrintTrait;

    #[storage]
    struct Storage {
        prefix: Array<felt252>
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let mut _prefix: Array<felt252> = ArrayTrait::new();

        _prefix.append('Abyssal');

        self.prefix.write(_prefix);
    }

    #[test]
    fn test(self: @ContractState) {}
}
