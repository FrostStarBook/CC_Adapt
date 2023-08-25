#[starknet::contract]
mod dungeonsSeeder {
    use array::ArrayTrait;
    use cc_map::utils::random::{random};

    #[storage]
    struct Storage {
        PREFIX: LegacyMap::<u8, felt252>,
        LAND: LegacyMap::<u8, felt252>,
        SUFFIXES: LegacyMap::<u8, felt252>,
        UNIQUE: LegacyMap::<u8, felt252>,
        PEOPLE: LegacyMap::<u8, felt252>
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

    fn get_seed(token_id: u64) -> u64 {
        let seed = starknet::get_block_timestamp();
        seed
    }

    fn get_size(seed: u64) -> u8 {
        let size = random(seed << 4, 8, 25);
        size
    }

    fn get_environment(seed: u64) -> u8 {
        let rand = random(seed << 8, 0, 100);

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

    fn get_name(seed: u64) -> (String, String, u8) {
        let unique_seed = random(seed << 15, 0, 10000);

        let (output, affinity, legendary) = if unique_seed < 17 {

            // Unique name
            let legendary = 1; 
            let affinity = "none";
            
            let output = UNIQUE[unique_seed].to_string();
        } else {
            let mut name_parts = [String::new(); 5];
            let base_seed = random(seed << 16, 0, 38);
            if unique_seed <= 300 {
                // Person's Name + Base Land
                let legendary = 0;
                let affinity = "none";

                name_parts[0] = PEOPLE[random(seed << 23, 0, 12)].to_string();
                name_parts[1] = " ".to_string(); 
                name_parts[2] = LAND[base_seed].to_string();

                let output = format!("{}{}", name_parts[0], name_parts[1], name_parts[2]);

            } else if unique_seed <= 1800 {

                // Prefix + Base Land + Suffix

                let legendary = 0;

                name_parts[0] = prefixes[random(seed << 42, 0, 29)].to_string();
                name_parts[1] = " ".to_string();
                name_parts[2] = LAND[base_seed].to_string(); 
                name_parts[3] = " of ".to_string();

                let affinity = SUFFIXES[random(seed << 27, 0, 59)].to_string();
                name_parts[4] = affinity.clone();

                let output = format!("{}{} {}{}", name_parts[0], name_parts[1], name_parts[2], name_parts[3], name_parts[4]);

            } else if unique_seed <= 4000 {

                // Base Land + Suffix

                let legendary = 0;
                let affinity = "none";

                name_parts[0] = LAND[base_seed].to_string();
                name_parts[1] = " of ".to_string();

                let affinity = SUFFIXES[random(seed << 51, 0, 59)].to_string();
                name_parts[2] = affinity;

                let output = format!("{} {}", name_parts[0], name_parts[1], name_parts[2]);

            } else if unique_seed <= 6500 {

                // Prefix + Base Land

                let legendary = 0; 
                let affinity = "none";

                name_parts[0] = prefixes[random(seed << 59, 0, 29)].to_string();
                name_parts[1] = " ".to_string();
                name_parts[2] = LAND[base_seed].to_string();

                let output = format!("{} {}", name_parts[0], name_parts[1], name_parts[2]);

            }else {
                // Base Land
                let legendary = 0;
                let affinity = "none";
                let output = LAND[base_seed].to_string();
            }

        }

        (output, affinity, legendary)
    }

    fn random(input: u64, min: u64, max: u64) -> u64 {
        let output = input % (max - min) + min;
        output
    }

}