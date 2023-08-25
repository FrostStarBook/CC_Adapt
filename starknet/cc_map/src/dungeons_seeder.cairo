#[starknet::contract]
mod dungeonsSeeder {
    use array::ArrayTrait;

    #[storage]
    struct Storage {
        _prefix: LegacyMap::<u8, felt252>
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self._prefix.write(0, 'Abyssal');
        self._prefix.write(1, 'Ancient');
        self._prefix.write(2, 'Bleak');
        self._prefix.write(3, 'Bright');
        self._prefix.write(4, 'Burning');
        self._prefix.write(5, 'Collapsed');
        self._prefix.write(6, 'Corrupted');
        self._prefix.write(7, 'Dark');
        self._prefix.write(8, 'Decrepid');
        self._prefix.write(9, 'Desolate');
        self._prefix.write(10, 'Dire');
        self._prefix.write(11, 'Divine');
        self._prefix.write(12, 'Emerald');
        self._prefix.write(13, 'Empyrean');
        self._prefix.write(14, 'Fallen');
        self._prefix.write(15, 'Glowing');
        self._prefix.write(16, 'Grim');
        self._prefix.write(17, 'Heaven\'s');
        self._prefix.write(18, 'Hidden');
        self._prefix.write(19, 'Holy');
        self._prefix.write(20, 'Howling');
        self._prefix.write(21, 'Inner');
        self._prefix.write(22, 'Morbid');
        self._prefix.write(23, 'Murky');
        self._prefix.write(24, 'Outer');
        self._prefix.write(25, 'Shimmering');
        self._prefix.write(26, 'Siren\'s');
        self._prefix.write(27, 'Sunken');
        self._prefix.write(28, 'Whispering');
    }
}
