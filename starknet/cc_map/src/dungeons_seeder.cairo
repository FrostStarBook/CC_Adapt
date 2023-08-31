#[starknet::contract]
mod DungeonsSeeder {
    use array::ArrayTrait;
    use option::OptionTrait;
    use traits::{Into, TryInto};
    use cc_map::utils::random::{random};
    use cc_map::interface::IDungeonsSeeder;

    #[storage]
    struct Storage {
        PREFIX: LegacyMap::<u256, felt252>,
        LAND: LegacyMap::<u256, felt252>,
        SUFFIXES: LegacyMap::<u256, felt252>,
        UNIQUE: LegacyMap::<u256, felt252>,
        PEOPLE: LegacyMap::<u256, felt252>
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        //init PREFIX
        self.PREFIX.write(0, 'Abyssal');
        self.PREFIX.write(1, 'Ancient');
        self.PREFIX.write(2, 'Bleak');
        self.PREFIX.write(3, 'Bright');
        self.PREFIX.write(4, 'Burning');
        self.PREFIX.write(5, 'Collapsed');
        self.PREFIX.write(6, 'Corrupted');
        self.PREFIX.write(7, 'Dark');
        self.PREFIX.write(8, 'Decrepid');
        self.PREFIX.write(9, 'Desolate');
        self.PREFIX.write(10, 'Dire');
        self.PREFIX.write(11, 'Divine');
        self.PREFIX.write(12, 'Emerald');
        self.PREFIX.write(13, 'Empyrean');
        self.PREFIX.write(14, 'Fallen');
        self.PREFIX.write(15, 'Glowing');
        self.PREFIX.write(16, 'Grim');
        self.PREFIX.write(17, 'Heaven\'s');
        self.PREFIX.write(18, 'Hidden');
        self.PREFIX.write(19, 'Holy');
        self.PREFIX.write(20, 'Howling');
        self.PREFIX.write(21, 'Inner');
        self.PREFIX.write(22, 'Morbid');
        self.PREFIX.write(23, 'Murky');
        self.PREFIX.write(24, 'Outer');
        self.PREFIX.write(25, 'Shimmering');
        self.PREFIX.write(26, 'Siren\'s');
        self.PREFIX.write(27, 'Sunken');
        self.PREFIX.write(28, 'Whispering');

        //init LAND
        self.LAND.write(0, 'Canyon');
        self.LAND.write(1, 'Catacombs');
        self.LAND.write(2, 'Cavern');
        self.LAND.write(3, 'Chamber');
        self.LAND.write(4, 'Cloister');
        self.LAND.write(5, 'Crypt');
        self.LAND.write(6, 'Den');
        self.LAND.write(7, 'Dunes');
        self.LAND.write(8, 'Field');
        self.LAND.write(9, 'Forest');
        self.LAND.write(10, 'Glade');
        self.LAND.write(11, 'Gorge');
        self.LAND.write(12, 'Graveyard');
        self.LAND.write(13, 'Grotto');
        self.LAND.write(14, 'Grove');
        self.LAND.write(15, 'Halls');
        self.LAND.write(16, 'Keep');
        self.LAND.write(17, 'Lair');
        self.LAND.write(18, 'Labyrinth');
        self.LAND.write(19, 'Landing');
        self.LAND.write(20, 'Maze');
        self.LAND.write(21, 'Mountain');
        self.LAND.write(22, 'Necropolis');
        self.LAND.write(23, 'Oasis');
        self.LAND.write(24, 'Passage');
        self.LAND.write(25, 'Peak');
        self.LAND.write(26, 'Prison');
        self.LAND.write(27, 'Scar');
        self.LAND.write(28, 'Sewers');
        self.LAND.write(29, 'Shrine');
        self.LAND.write(30, 'Sound');
        self.LAND.write(31, 'Steppes');
        self.LAND.write(32, 'Temple');
        self.LAND.write(33, 'Tundra');
        self.LAND.write(34, 'Tunnel');
        self.LAND.write(35, 'Valley');
        self.LAND.write(36, 'Waterfall');
        self.LAND.write(37, 'Woods');

        //init SUFFIXES
        self.SUFFIXES.write(0, 'Agony');
        self.SUFFIXES.write(1, 'Anger');
        self.SUFFIXES.write(2, 'Blight');
        self.SUFFIXES.write(3, 'Bone');
        self.SUFFIXES.write(4, 'Brilliance');
        self.SUFFIXES.write(5, 'Brimstone');
        self.SUFFIXES.write(6, 'Corruption');
        self.SUFFIXES.write(7, 'Despair');
        self.SUFFIXES.write(8, 'Dread');
        self.SUFFIXES.write(9, 'Dusk');
        self.SUFFIXES.write(10, 'Enlightenment');
        self.SUFFIXES.write(11, 'Fury');
        self.SUFFIXES.write(12, 'Fire');
        self.SUFFIXES.write(13, 'Giants');
        self.SUFFIXES.write(14, 'Gloom');
        self.SUFFIXES.write(15, 'Hate');
        self.SUFFIXES.write(16, 'Havoc');
        self.SUFFIXES.write(17, 'Honour');
        self.SUFFIXES.write(18, 'Horror');
        self.SUFFIXES.write(19, 'Loathing');
        self.SUFFIXES.write(20, 'Mire');
        self.SUFFIXES.write(21, 'Mist');
        self.SUFFIXES.write(22, 'Needles');
        self.SUFFIXES.write(23, 'Pain');
        self.SUFFIXES.write(24, 'Pandemonium');
        self.SUFFIXES.write(25, 'Pine');
        self.SUFFIXES.write(26, 'Rage');
        self.SUFFIXES.write(27, 'Rapture');
        self.SUFFIXES.write(28, 'Sand');
        self.SUFFIXES.write(29, 'Sorrow');
        self.SUFFIXES.write(30, 'the Apocalypse');
        self.SUFFIXES.write(31, 'the Beast');
        self.SUFFIXES.write(32, 'the Behemoth');
        self.SUFFIXES.write(33, 'the Brood');
        self.SUFFIXES.write(34, 'the Fox');
        self.SUFFIXES.write(35, 'the Gale');
        self.SUFFIXES.write(36, 'the Golem');
        self.SUFFIXES.write(37, 'the Kraken');
        self.SUFFIXES.write(38, 'the Leech');
        self.SUFFIXES.write(39, 'the Moon');
        self.SUFFIXES.write(40, 'the Phoenix');
        self.SUFFIXES.write(41, 'the Plague');
        self.SUFFIXES.write(42, 'the Root');
        self.SUFFIXES.write(43, 'the Song');
        self.SUFFIXES.write(44, 'the Stars');
        self.SUFFIXES.write(45, 'the Storm');
        self.SUFFIXES.write(46, 'the Sun');
        self.SUFFIXES.write(47, 'the Tear');
        self.SUFFIXES.write(48, 'the Titans');
        self.SUFFIXES.write(49, 'the Twins');
        self.SUFFIXES.write(50, 'the Willows');
        self.SUFFIXES.write(51, 'the Wisp');
        self.SUFFIXES.write(52, 'the Viper');
        self.SUFFIXES.write(53, 'the Vortex');
        self.SUFFIXES.write(54, 'Torment');
        self.SUFFIXES.write(55, 'Vengeance');
        self.SUFFIXES.write(56, 'Victory');
        self.SUFFIXES.write(57, 'Woe');
        self.SUFFIXES.write(58, 'Wisdom');
        self.SUFFIXES.write(59, 'Wrath');

        //init UNIQUE
        self.UNIQUE.write(0, 'Wrath');
        self.UNIQUE.write(1, '\'Armageddon\'');
        self.UNIQUE.write(2, '\'Mind\'s Eye\'');
        self.UNIQUE.write(3, '\'Nostromo\'');
        self.UNIQUE.write(4, '\'Oblivion\'');
        self.UNIQUE.write(5, '\'The Chasm\'');
        self.UNIQUE.write(6, '\'The Crypt\'');
        self.UNIQUE.write(7, '\'The Depths\'');
        self.UNIQUE.write(8, '\'The End\'');
        self.UNIQUE.write(9, '\'The Expanse\'');
        self.UNIQUE.write(10, '\'The Gale\'');
        self.UNIQUE.write(11, '\'The Hook\'');
        self.UNIQUE.write(12, '\'The Maelstrom\'');
        self.UNIQUE.write(13, '\'The Mouth\'');
        self.UNIQUE.write(14, '\'The Muck\'');
        self.UNIQUE.write(15, '\'The Shelf\'');
        self.UNIQUE.write(16, '\'The Vale\'');
        self.UNIQUE.write(17, '\'The Veldt\'');

        //init PEOPLE
        self.PEOPLE.write(0, 'Fate\'s');
        self.PEOPLE.write(1, 'Fohd\'s');
        self.PEOPLE.write(2, 'Gremp\'s');
        self.PEOPLE.write(3, 'Hate\'s');
        self.PEOPLE.write(4, 'Kali\'s');
        self.PEOPLE.write(5, 'Kiv\'s');
        self.PEOPLE.write(6, 'Light\'s');
        self.PEOPLE.write(7, 'Shub\'s');
        self.PEOPLE.write(8, 'Sol\'s');
        self.PEOPLE.write(9, 'Tish\'s');
        self.PEOPLE.write(10, 'Viper\'s');
        self.PEOPLE.write(11, 'Woe\'s');
    }

    #[external(v0)]
    impl IDungeonsSeederImpl of IDungeonsSeeder<ContractState> {
        fn get_seed(self: @ContractState, token_id: u256) -> u256 {
            let block_time = starknet::get_block_timestamp();
            let b_u256_time: u256 = block_time.into();
            let input = array![b_u256_time, token_id];
            let seed = keccak::keccak_u256s_be_inputs(input.span());
            seed
        }

        fn get_size(self: @ContractState, seed: u64) -> u8 {
            let size = random(seed.into(), 8_u128, 25_u128);
            size.try_into().unwrap()
        }

        fn get_environment(self: @ContractState, seed: u64) -> u8 {
            let rand = random(seed.into(), 0_u128, 100_u128);

            if rand >= 70 {
                0
            } else if rand >= 45 {
                1
            } else if rand >= 25 {
                2
            } else if rand >= 13 {
                3
            } else if rand >= 4 {
                4
            } else {
                5
            }
        }

        fn get_name(self: @ContractState, seed: u128) -> (Array<felt252>, felt252, u8) {
            let unique_seed = random(bit_operation_left(seed, 15_u32), 0_u128, 10000_u128);
            let mut name_parts = ArrayTrait::<felt252>::new();
            let affinity = 'none';
            let legendary = 0;

            if (unique_seed < 17) {
                // Unique name
                let legendary = 1;
                let a = self.UNIQUE.read(unique_seed);
                name_parts.append(a);
                return (name_parts, affinity, legendary);
            } else {
                let base_seed = random(bit_operation_left(seed, 16_u32), 0_u128, 38_u128);
                if unique_seed <= 300 {
                    // Person's Name + Base Land
                    let people_seed = random(bit_operation_left(seed, 23_u32), 0_u128, 12_u128);
                    name_parts.append(self.PEOPLE.read(people_seed.into()));
                    name_parts.append(' ');
                    name_parts.append(self.LAND.read(base_seed.into()));
                } else if unique_seed <= 1800 {
                    // Prefix + Base Land + Suffix
                    let suffixs_random = random(bit_operation_left(seed, 27_u32), 0_u128, 59_u128);
                    let affinity = self.SUFFIXES.read(suffixs_random);
                    let prefix_seed = random(bit_operation_left(seed, 42_u32), 0_u128, 29_u128);

                    name_parts.append(self.PREFIX.read(prefix_seed.into()));
                    name_parts.append(' ');
                    name_parts.append(self.LAND.read(base_seed.into()));
                    name_parts.append(' of ');
                    name_parts.append(affinity);
                } else if unique_seed <= 4000 {
                    // Base Land + Suffix
                    let suffixs_random = random(bit_operation_left(seed, 51_u32), 0_u128, 59_u128);

                    name_parts.append(self.LAND.read(base_seed.into()));
                    name_parts.append(' of ');
                    name_parts.append(self.SUFFIXES.read(suffixs_random));
                } else if unique_seed <= 6500 {
                    // Prefix + Base Land
                    let affinity = self.LAND.read(base_seed.into());
                    let prefix_seed = random(bit_operation_left(seed, 59_u32), 0_u128, 29_u128);

                    name_parts.append(self.PREFIX.read(prefix_seed.into()));
                    name_parts.append(' ');
                    name_parts.append(affinity);
                } else {
                    // Base Land
                    name_parts.append(self.LAND.read(base_seed.into()));
                }
            };
            return (name_parts, affinity, legendary);
        }
    }

    fn bit_operation_left(seed: u128, bits: u32) -> u128 {
        let mut _seed = seed;
        let mut _bits: usize = bits;
        loop {
            if _bits < 1 {
                break;
            }

            _seed *= 2;
            _bits -= 1;
        };
        return _seed;
    }

    #[test]
    #[available_gas(30000000)]
    fn test_bit_operation_left() {
        let mut seed = 3_u128;

        let result = bit_operation_left(seed, 5_u32);
        assert(result == 96, 'bit_operation normal');
    }
}

