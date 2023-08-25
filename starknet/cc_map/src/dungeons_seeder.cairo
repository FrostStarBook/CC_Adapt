#[starknet::contract]
mod dungeonsSeeder {
    use array::ArrayTrait;

    #[storage]
    struct Storage {
        prefix: Array<felt252>
    }

    #[constructor]
    fn constructor(ref self: ContractState) {

        let mut _prefix: Array<felt252> = ArrayTrait::new();
        _prefix.append('Abyssal');
        _prefix.append('Ancient');
        _prefix.append('Bleak');
        _prefix.append('Bright');
        _prefix.append('Burning');
        _prefix.append('Collapsed');
        _prefix.append('Corrupted');
        _prefix.append('Dark');
        _prefix.append('Decrepid');
        _prefix.append('Desolate');
        _prefix.append('Dire');
        _prefix.append('Divine');
        _prefix.append('Emerald');
        _prefix.append('Empyrean');
        _prefix.append('Fallen');
        _prefix.append('Glowing');
        _prefix.append('Grim');
        _prefix.append('Heaven\'s');
        _prefix.append('Hidden');
        _prefix.append('Holy');
        _prefix.append('Howling');
        _prefix.append('Inner');
        _prefix.append('Morbid');
        _prefix.append('Murky');
        _prefix.append('Outer');
        _prefix.append('Shimmering');
        _prefix.append('Siren\'s');
        _prefix.append('Sunken');
        _prefix.append('Whispering');

        self.prefix.write(_prefix);
    }
}
