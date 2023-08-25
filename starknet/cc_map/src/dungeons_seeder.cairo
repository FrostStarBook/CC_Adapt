#[starknet::contract]
mod dungeonsSeeder {
    use array::ArrayTrait;

    #[storage]
    struct Storage {
        _prefix: LegacyMap::<u256, felt252>
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self._prefix.write(0, 'Abyssal');
        self._prefix.write(0, 'Ancient');
    }
}
