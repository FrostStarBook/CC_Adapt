mod dungeons_generator;
mod utils;
mod test;


#[starknet::contract]
mod Dungeons {
    // ------------------------------------------ Imports -------------------------------------------
    use core::byte_array::ByteArrayTrait;
    use core::traits::Into;
    use core::array::ArrayTrait;
    use core::clone::Clone;
    use starknet::{ContractAddress, info::get_caller_address};
    use super::{
        utils::{random::{random}, bit_operation::BitOperationTrait, pack::{PackTrait, Pack}},
        dungeons_generator as generator
    };

    use openzeppelin::token::erc721::ERC721;

    // ------------------------------------------- Structs -------------------------------------------

    #[derive(Copy, Drop, Serde)]
    struct DungeonSerde {
        size: u8,
        environment: u8,
        structure: u8,
        legendary: u8,
        layout: Pack,
        entities: EntityData,
        affinity: felt252,
        dungeon_name: Span<felt252>
    }

    #[derive(Clone, Drop)]
    struct Dungeon {
        size: u8,
        environment: u8,
        structure: u8,
        legendary: u8,
        layout: Pack,
        entities: EntityData,
        affinity: felt252,
        dungeon_name: Array<felt252>
    }

    #[derive(Copy, Drop, Serde)]
    struct EntityData {
        x: Span<u8>,
        y: Span<u8>,
        entity_data: Span<u8>
    }

    /// Data structure that stores our different maps (layout, doors, points)
    #[derive(Drop)]
    struct Maps {
        layout: Span<(u8, u8)>,
        doors: Span<(u8, u8)>,
        points: Span<(u8, u8)>,
    }

    /// Helper variables when iterating through and drawing dungeon tiles
    #[derive(Drop)]
    struct RenderHelper {
        pixel: u128,
        start: u128,
        layout: Pack,
        parts: Span<felt252>,
        counter: u128,
        num_rects: u128,
        last_start: u128,
    }

    #[derive(Copy, Drop)]
    struct EntityHelper {
        size: u256,
        environment: u256,
    }

    // ------------------------------------------- Event -------------------------------------------

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Minted: Minted,
        Claimed: Claimed
    }

    #[derive(Drop, starknet::Event)]
    struct Minted {
        #[key]
        account: ContractAddress,
        token_id: u128
    }

    #[derive(Drop, starknet::Event)]
    struct Claimed {
        #[key]
        account: ContractAddress,
        token_id: u128
    }

    // ------------------------------------------- Storage -------------------------------------------

    #[storage]
    struct Storage {
        // -------------- dungeons ----------------
        // price: u256,
        // loot:ContractAddress,
        seeds: LegacyMap::<u128, u256>,
        last_mint: u128,
        claimed: u128,
        restricted: bool,
        // --------------- seeder ----------------
        PREFIX: LegacyMap::<u128, felt252>,
        LAND: LegacyMap::<u128, felt252>,
        SUFFIXES: LegacyMap::<u128, felt252>,
        UNIQUE: LegacyMap::<u128, felt252>,
        PEOPLE: LegacyMap::<u128, felt252>,
        // --------------- render ----------------
        // Array contains sets of 4 colors:
        // 0 = bg, 1 = wall, 2 = door, 3 = point
        // To calculate, multiply environment (int 0-5) by 4 and add the above numbers.
        colors: LegacyMap::<u8, felt252>,
        // Names mapped to the above colors
        environmentName: LegacyMap::<u8, felt252>
    }

    // ------------------------------------------- Dungeon -------------------------------------------

    #[external(v0)]
    fn test_get_svg(self: @ContractState, seed: u256) -> Array<felt252> {
        draw(self, test_generate_dungeon(self, seed))
    }

    #[external(v0)]
    fn test_get_layout(self: @ContractState, seed: u256) -> (Pack, u8) {
        get_layout(self, seed, get_size_in(self, seed))
    }

    #[external(v0)]
    fn test_get_name(self: @ContractState, seed: u256) -> (Array<felt252>, felt252, u8) {
        get_name_in(self, seed)
    }

    #[external(v0)]
    fn test_get_entities(self: @ContractState, seed: u256) -> (Array<u8>, Array<u8>, Array<u8>) {
        generator::get_entities(seed, get_size_in(self, seed))
    }

    #[external(v0)]
    fn test_generate_dungeon(self: @ContractState, seed: u256) -> DungeonSerde {
        let size = get_size_in(self, seed);

        let (x_array, y_array, t_array) = generator::get_entities(seed, size);
        let (mut layout, structure) = get_layout(self, seed, size);
        let (mut dungeon_name, mut affinity, legendary) = get_name_in(self, seed);

        DungeonSerde {
            size: size.try_into().unwrap(),
            environment: get_environment_in(self, seed),
            structure: structure,
            legendary: legendary,
            layout: layout,
            entities: EntityData {
                x: x_array.span(), y: y_array.span(), entity_data: t_array.span()
            },
            affinity: affinity,
            dungeon_name: dungeon_name.span()
        }
    }

    // ------ ERC721 -------
    #[external(v0)]
    fn mint(ref self: ContractState) -> u128 {
        assert(self.last_mint.read() < 9000, 'Token sold out');
        // assert(!self.restricted.read(), 'Dungeon is restricted');

        let user = get_caller_address();
        let token_id = self.last_mint.read() + 1;
        self.last_mint.write(token_id);
        self.seeds.write(token_id, get_seed(token_id));

        let mut state = ERC721::unsafe_new_contract_state();
        ERC721::InternalImpl::_mint(ref state, user, token_id.into());
        self.emit(Minted { account: user, token_id });
        token_id
    }

    #[external(v0)]
    fn owner_of(self: @ContractState, token_id: u128) -> ContractAddress {
        let mut state = ERC721::unsafe_new_contract_state();
        ERC721::InternalImpl::_owner_of(@state, token_id.into())
    }

    #[external(v0)]
    fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
        let mut state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::balance_of(@state, account)
    }

    #[external(v0)]
    fn safe_transfer_from(
        self: @ContractState, from: ContractAddress, to: ContractAddress, token_id: u128
    ) {
        let mut state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::safe_transfer_from(
            ref state, from, to, token_id.into(), ArrayTrait::<felt252>::new().span()
        );
    }

    #[external(v0)]
    fn transfer_from(
        self: @ContractState, from: ContractAddress, to: ContractAddress, token_id: u128
    ) {
        let mut state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::transfer_from(ref state, from, to, token_id.into());
    }

    #[external(v0)]
    fn approve(ref self: ContractState, to: ContractAddress, token_id: u128) {
        let mut state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::approve(ref state, to, token_id.into());
    }

    #[external(v0)]
    fn set_approval_for_all(ref self: ContractState, operator: ContractAddress, approved: bool) {
        let mut state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::set_approval_for_all(ref state, operator, approved);
    }

    #[external(v0)]
    fn get_approved(self: @ContractState, token_id: u128) -> ContractAddress {
        let mut state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::get_approved(@state, token_id.into())
    }

    #[external(v0)]
    fn is_approved_for_all(
        self: @ContractState, owner: ContractAddress, operator: ContractAddress
    ) -> bool {
        let mut state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::is_approved_for_all(@state, owner, operator)
    }

    // ------ Dungeon -------
    #[external(v0)]
    fn get_seeds(self: @ContractState, token_id: u128) -> u256 {
        is_valid(self, token_id.into());
        self.seeds.read(token_id)
    }

    #[external(v0)]
    fn token_URI_not_work_yet(self: @ContractState, token_id: u128) -> Span<felt252> {
        is_valid(self, token_id.into());
        let dungeon = generate_dungeon(self, token_id);
        render_token_URI(self, token_id.into(), dungeon).span()
    }

    #[external(v0)]
    fn get_svg(self: @ContractState, token_id: u128) -> Array<felt252> {
        is_valid(self, token_id.into());
        draw(self, generate_dungeon(self, token_id))
    }

    #[external(v0)]
    fn generate_dungeon(self: @ContractState, token_id: u128) -> DungeonSerde {
        is_valid(self, token_id.into());
        let seed: u256 = self.seeds.read(token_id);
        let size = get_size_in(self, seed);

        let (x_array, y_array, t_array) = generator::get_entities(seed, size);
        let (mut layout, structure) = get_layout(self, seed, size);
        let (mut dungeon_name, mut affinity, legendary) = get_name_in(self, seed);

        DungeonSerde {
            size: size.try_into().unwrap(),
            environment: get_environment_in(self, seed),
            structure: structure,
            legendary: legendary,
            layout: layout,
            entities: EntityData {
                x: x_array.span(), y: y_array.span(), entity_data: t_array.span()
            },
            affinity: affinity,
            dungeon_name: dungeon_name.span()
        }
    }

    #[external(v0)]
    fn get_entities(self: @ContractState, token_id: u128) -> EntityData {
        // 'get_entities'.print();
        // is_valid(self, token_id);

        let seed = self.seeds.read(token_id);
        let (x_array, y_array, t_array) = generator::get_entities(seed, get_size_in(self, seed));

        EntityData { x: x_array.span(), y: y_array.span(), entity_data: t_array.span() }
    }

    #[external(v0)]
    fn get_layout(self: @ContractState, seed: u256, size: u128) -> (Pack, u8) {
        // 'get_layout'.print();
        // is_valid(self, token_id);

        generator::get_layout(seed, size)
    }

    fn is_valid(self: @ContractState, token_id: u256) {
        assert(
            ERC721::InternalImpl::_exists(@ERC721::unsafe_new_contract_state(), token_id),
            'Valid token'
        );
    }

    // --------------------------------------------- Seeder --------------------------------------------

    // for testnet only
    fn get_seed(token_id: u128) -> u256 {
        let block_time = starknet::get_block_timestamp();
        let b_u256_time: u256 = block_time.into();
        let input = array![b_u256_time, token_id.into()];
        let seed = keccak::keccak_u256s_be_inputs(input.span());
        seed
    }

    #[external(v0)]
    fn get_size(self: @ContractState, token_id: u128) -> u128 {
        get_size_in(self, get_seed(token_id))
    }

    fn get_size_in(self: @ContractState, seed: u256) -> u128 {
        random(seed.left_shift(4), 8, 25)
    }

    #[external(v0)]
    fn get_environment(self: @ContractState, token_id: u128) -> u8 {
        get_environment_in(self, get_seed(token_id))
    }

    fn get_environment_in(self: @ContractState, seed: u256) -> u8 {
        let rand = random(seed.left_shift(8), 0, 100);

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


    #[external(v0)]
    fn get_name(self: @ContractState, token_id: u128) -> (Array<felt252>, felt252, u8) {
        get_name_in(self, get_seed(token_id))
    }

    fn get_name_in(self: @ContractState, seed: u256) -> (Array<felt252>, felt252, u8) {
        // 'get_name'.print();
        let unique_seed = random(seed.left_shift(15), 0, 10000);

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
            let base_seed = random(seed.left_shift(16), 0, 38);

            if unique_seed <= 300 {
                // Person's Name + Base Land
                let people_seed = random(seed.left_shift(23), 0, 12);

                name_parts.append(self.PEOPLE.read(people_seed));
                name_parts.append(' ');
                name_parts.append(self.LAND.read(base_seed));
            } else if unique_seed <= 1800 {
                // Prefix + Base Land + Suffix
                let suffixs_random = random(seed.left_shift(27), 0, 59);
                let affinity = self.SUFFIXES.read(suffixs_random);
                let prefix_seed = random(seed.left_shift(42), 0, 29);

                name_parts.append(self.PREFIX.read(prefix_seed));
                name_parts.append(' ');
                name_parts.append(self.LAND.read(base_seed));
                name_parts.append(' of ');
                name_parts.append(affinity);
            } else if unique_seed <= 4000 {
                // Base Land + Suffix
                let suffixs_random = random(seed.left_shift(51), 0, 59);

                name_parts.append(self.LAND.read(base_seed));
                name_parts.append(' of ');
                name_parts.append(self.SUFFIXES.read(suffixs_random));
            } else if unique_seed <= 6500 {
                // Prefix + Base Land
                let affinity = self.LAND.read(base_seed);
                let prefix_seed = random(seed.left_shift(59), 0, 29);

                name_parts.append(self.PREFIX.read(prefix_seed));
                name_parts.append(' ');
                name_parts.append(affinity);
            } else {
                // Base Land
                name_parts.append(self.LAND.read(base_seed));
            }
        };
        return (name_parts, affinity, legendary);
    }

    // --------------------------------------------- Render --------------------------------------------

    fn append_number_ascii(mut parts: Array<felt252>, mut num: u128) -> Array<felt252> {
        let part: Array<felt252> = append_number(ArrayTrait::<felt252>::new(), num);
        let mut length = part.len();
        loop {
            if length == 0 {
                break;
            }
            parts.append(*part[length - 1]);
            length -= 1;
        };
        parts
    }

    fn append_number(mut part: Array<felt252>, mut num: u128) -> Array<felt252> {
        if num != 0 {
            let temp: u8 = (num % 10).try_into().unwrap();
            part.append((temp + 48).into());
            num /= 10;
            append_number(part, num)
        } else {
            part
        }
    }

    fn draw(self: @ContractState, dungeon: DungeonSerde) -> Array<felt252> {
        let x = dungeon.entities.x;
        let y = dungeon.entities.y;
        let entity_data = dungeon.entities.entity_data;

        // Hardcoded to save memory: Width = 100
        // Setup SVG and draw our background
        // We write at 100x100 and scale it 5x to 500x500 to avoid safari small rendering
        let mut parts: Array<felt252> = ArrayTrait::new();
        parts.append('<svg xmlns=');
        parts.append('"http://www.w3.org/2000/svg"');
        parts.append(' preserveAspectRatio=');
        parts.append('"xMinYMin meet"');
        parts.append(' viewBox="0 0 500 500"');
        parts.append(' shape-rendering="crispEdges"');
        parts.append(' transform-origin="center">');
        parts.append('<rect width="100%"');
        parts.append(' height="100%" fill="#');
        parts.append(self.colors.read(dungeon.environment * 4));
        parts.append('" />');

        parts = draw_name_plate(parts, dungeon.dungeon_name);
        let (start, pixel) = get_width(dungeon.size);
        let mut helper: RenderHelper = RenderHelper {
            pixel: pixel,
            start: start,
            layout: dungeon.layout,
            parts: array![].span(),
            counter: 0,
            num_rects: 0,
            last_start: 0
        };

        parts = append(parts, (chunk_dungeon(self, dungeon, ref helper)).span());
        parts = append(parts, draw_entities(self, x, y, entity_data, dungeon, helper).span());
        parts.append('</svg>');

        parts
    }

    // fn arr_to_dict(origin: Span<u256>) -> Felt252Dict<Nullable<u256>> {
    //     let mut result: Felt252Dict<Nullable<u256>> = Default::default();

    //     let limit = origin.len();
    //     let mut count = 0;
    //     loop {
    //         if count == limit {
    //             break;
    //         }

    //         result.update(count.into(), *origin[count]);
    //         count += 1;
    //     };

    //     result
    // }
    use generator::p;
    fn chunk_dungeon(
        self: @ContractState, dungeon: DungeonSerde, ref helper: RenderHelper
    ) -> Array<felt252> {
        let mut layout = dungeon.layout;
        let mut parts: Array<felt252> = ArrayTrait::new();

        let mut y = 0;
        loop {
            if y == dungeon.size {
                break;
            }

            helper.last_start = helper.counter;
            let mut row_parts: Array<felt252> = ArrayTrait::new();

            let mut x = 0;
            loop {
                if x == dungeon.size {
                    break;
                }

                if layout.get_bit(helper.counter)
                    && helper.counter > 0
                    && !layout.get_bit(helper.counter - 1) {
                    helper.num_rects += 1;

                    row_parts =
                        draw_tile(
                            row_parts,
                            helper.start + (helper.last_start % dungeon.size.into()) * helper.pixel,
                            helper.start + (helper.last_start / dungeon.size.into()) * helper.pixel,
                            (helper.counter - helper.last_start) * helper.pixel,
                            helper.pixel,
                            self.colors.read(dungeon.environment * 4 + 1)
                        );
                } else if !layout.get_bit(helper.counter)
                    && helper.counter > 0
                    && layout.get_bit(helper.counter - 1) {
                    helper.last_start = helper.counter;
                }

                helper.counter += 1;
                x += 1;
            };

            if !layout.get_bit(helper.counter - 1) {
                helper.num_rects += 1;
                row_parts =
                    draw_tile(
                        row_parts,
                        helper.start + (helper.last_start % dungeon.size.into()) * helper.pixel,
                        helper.start + (helper.last_start / dungeon.size.into()) * helper.pixel,
                        (helper.counter - helper.last_start) * helper.pixel,
                        helper.pixel,
                        self.colors.read(dungeon.environment * 4 + 1)
                    );
            }

            parts = append(parts, row_parts.span());
            y += 1;
        };

        parts
    }


    fn draw_name_plate(mut parts: Array<felt252>, name: Span<felt252>) -> Array<felt252> {
        let mut name_length = count_length(name);

        let mut font_size = 0;
        let mut multiplier = 0;
        if name_length <= 25 {
            font_size = 5;
            multiplier = 3;
        } else {
            font_size = 4;
            multiplier = 2;
            name_length += 7;
        }

        parts.append('<g transform="scale ');
        parts.append('(5 5)"><rect x="');
        parts = append_number_ascii(parts, (100 - ((name_length + 3) * multiplier)) / 2);
        parts.append('" y="-1" width="');
        parts = append_number_ascii(parts, (name_length + 3) * multiplier);
        parts.append('" height="9" stroke-width="0.3"');
        parts.append(' stroke="black" fill="#FFA800"');
        parts.append(' />');

        parts.append('<text x="50" y="5.5" width="');
        parts = append_number_ascii(parts, name_length * 3);
        parts.append('" font-family="monospace" ');
        parts.append('font-size="');
        parts = append_number_ascii(parts, font_size);
        parts.append('" text-anchor="middle">');
        parts = append(parts, name);
        parts.append('</text></g>');

        parts
    }

    // Draw each entity as a pixel on the map
    fn draw_entities(
        self: @ContractState,
        x: Span<u8>,
        y: Span<u8>,
        entityData: Span<u8>,
        dungeon: DungeonSerde,
        helper: RenderHelper
    ) -> Array<felt252> {
        let mut parts: Array<felt252> = ArrayTrait::new();

        let mut i: usize = 0;
        loop {
            if i == entityData.len() {
                break;
            }
            let x = helper.start + (*x[i] % dungeon.size).into() * helper.pixel;
            let y = helper.start + (*y[i]).into() * helper.pixel;
            let color_index: u8 = dungeon.environment * 4 + 2 + *entityData[i];
            let color: felt252 = self.colors.read(color_index);
            parts = draw_tile(parts, x, y, helper.pixel, helper.pixel, color);

            i += 1;
        };
        parts
    }

    fn draw_tile(
        mut tile: Array<felt252>, x: u128, y: u128, width: u128, pixel: u128, color: felt252
    ) -> Array<felt252> {
        tile.append('<rect x="');
        tile = append_number_ascii(tile, x);
        tile.append('" y="');
        tile = append_number_ascii(tile, y);
        tile.append('" width="');
        tile = append_number_ascii(tile, width);
        tile.append('" height="');
        tile = append_number_ascii(tile, pixel);
        tile.append('" fill="#');
        tile.append(color);
        tile.append('" />');

        tile
    }

    fn get_width(size: u8) -> (u128, u128) {
        let size = size.into();
        let pixel = 500 / (size + 3 * 2);
        let start = (500 - pixel * size) / 2;
        (start, pixel)
    }

    fn count_length(parts: Span<felt252>) -> u128 {
        let limit = parts.len();
        let mut length = 0;
        let mut count = 0;
        loop {
            if count == limit {
                break;
            }
            let mut part: u256 = (*parts[count]).into();
            loop {
                if part == 0 {
                    break;
                }
                part = part.right_shift(8);
                length += 1;
            };
            count += 1;
        };
        length
    }

    fn append(mut parts: Array<felt252>, mut to_add: Span<felt252>) -> Array<felt252> {
        let pop = to_add.pop_front();

        if (match pop {
            Option::Some(v) => true,
            Option::None => false
        }) {
            parts.append(*pop.unwrap());
            append(parts, to_add)
        } else {
            parts
        }
    }


    fn render_token_URI(
        self: @ContractState, tokenId: u256, dungeon: DungeonSerde
    ) -> Array<felt252> {
        let (points, doors) = generator::count_entities(dungeon.entities.entity_data);

        // Generate dungeon
        let mut output = draw(self, dungeon);

        // Base64 Encode svg and output
        let mut json: Array<felt252> = ArrayTrait::new();
        json.append('{"name": "Crypts and Caverns #');
        json.append(tokenId.try_into().unwrap());
        json.append('", "description": "Crypts and ');
        json.append('Caverns is an onchain map ');
        json.append('generator that produces an ');
        json.append('infinite set of dungeons. ');
        json.append('Enemies, treasure, etc ');
        json.append('intentionally omitted for');
        json.append(' others to interpret. ');
        json.append('Feel free to use Crypts and ');
        json.append('Caverns in any way you want."');
        json.append(', "attributes": [ {');
        json.append('"trait_type": "name", ');
        json.append('"value": "');
        json = append(json, dungeon.dungeon_name);
        json.append('"}, {"trait_type": ');
        json.append('"size", "value": "');
        json.append(dungeon.size.into());
        json.append('x');
        json.append(dungeon.size.into());
        json.append('"}, {"trait_type": ');
        json.append('"environment", "value": "');
        json.append(self.environmentName.read(dungeon.environment));
        json.append('"}, {"trait_type": ');
        json.append('"doors", "value": "');
        json.append(doors.into());
        json.append('"}, {"trait_type": ');
        json.append('"points of interest",');
        json.append(' "value": "');
        json.append(points.into());
        json.append('"}, {"trait_type":');
        json.append(' "affinity", "value": "');
        json.append(dungeon.affinity);
        json.append('"}, {"trait_type":');
        json.append(' "legendary", "value": "');
        if (dungeon.legendary == 1) {
            json.append('Yes');
        } else {
            json.append('No');
        }
        if (dungeon.structure == 0) {
            json.append('Crypt');
        } else {
            json.append('Cavern');
        }
        json.append('"}],"image":');
        json.append(' "data:image/svg+xml;base64,');
        // TODO base64 encode svg

        json.append('"}');
        // TODO base64 encode json

        output.append('data:application/json;base64,');
        // output.append(json);

        output
    }

    // ------------------------------------------ Constructor ------------------------------------------

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.restricted.write(false);
        self.last_mint.write(0);
        self.claimed.write(0);

        // --------------- seeder ---------------
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

        // --------------- render --------------
        // Init colors
        // Desert
        self.colors.write(0, 'F3D899');
        self.colors.write(1, '160F09');
        self.colors.write(2, 'FAAA00');
        self.colors.write(3, '00A29D');
        // Stone Temple
        self.colors.write(4, '967E67');
        self.colors.write(5, 'F3D899');
        self.colors.write(6, '3C2A1A');
        self.colors.write(7, '006669');
        // Forest Ruins
        self.colors.write(8, '2F590E');
        self.colors.write(9, 'A98C00');
        self.colors.write(10, '802F1A');
        self.colors.write(11, 'C55300');
        // Mountain Deep
        self.colors.write(12, '36230F');
        self.colors.write(13, '744936');
        self.colors.write(14, '802F1A');
        self.colors.write(15, 'FFA800');
        // Underwater Keep
        self.colors.write(16, '006669');
        self.colors.write(17, '004238');
        self.colors.write(18, '967E67');
        self.colors.write(19, 'F9B569');
        // Ember"s Glow
        self.colors.write(20, '340D07');
        self.colors.write(21, '5D0503');
        self.colors.write(22, 'B75700');
        self.colors.write(23, 'FF1800');
        // Init environmentName
        self.environmentName.write(0, 'Desert Oasis');
        self.environmentName.write(1, 'Stone Temple');
        self.environmentName.write(2, 'Forest Ruins');
        self.environmentName.write(3, 'Mountain Deep');
        self.environmentName.write(4, 'Underwater Keep');
        self.environmentName.write(5, 'Embers Glow');
    }
}
