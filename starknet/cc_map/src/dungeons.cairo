#[starknet::contract]
mod Dungeons {
    use core::array::ArrayTrait;
    use starknet::ContractAddress;
    use openzeppelin::token::erc721::ERC721;
    use openzeppelin::security::reentrancyguard::ReentrancyGuard;
    use cc_map::dungeons_generator as generator;
    use cc_map::dungeons_seeder as seeder;
    use cc_map::dungeons_generator::MapTrait;
    use cc_map::utils::map;

    // ------------------------------------------- Structs -------------------------------------------

    #[derive(Copy, Drop, Serde)]
    struct Dungeon {
        size: u8,
        environment: u8,
        structure: u8,
        legendary: u8,
        layout: Span<u256>,
        entities: EntityData,
        affinity: felt252,
        dungeon_name: Span<felt252>
    }

    #[derive(Copy, Drop, Serde)]
    struct EntityData {
        x: Span<u8>,
        y: Span<u8>,
        entity_data: Span<u8>
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
        token_id: u256
    }

    #[derive(Drop, starknet::Event)]
    struct Claimed {
        #[key]
        account: ContractAddress,
        token_id: u256
    }

    // ------------------------------------------- Storage -------------------------------------------

    #[storage]
    struct Storage {
        // price: u256,
        // loot:ContractAddress,
        seeds: LegacyMap::<u256, u256>,
        last_mint: u256,
        claimed: u256,
        restructed: bool,
    }

    // ------------------------------------------ Constructor ------------------------------------------

    #[constructor]
    fn constructor(ref self: ContractState) {
        let mut unsafe_new_contract_state = ERC721::unsafe_new_contract_state();
    }

    // ------------------------------------------- Functions -------------------------------------------

    #[external(v0)]
    fn claim(ref self: ContractState, token_id: u256) {}

    fn generate_dungeon(token_id: u256) -> Dungeon {
        let seed: u256 = 0;
        let size: u256 = 0;
        let (mut layout, structure) = get_layout(seed, size, token_id);
        let mut entity_data = get_entities(token_id);
        // let (mut dungeon_name, mut affinity, legendary) = seeder::get_name();

        Dungeon {
            size: 0,
            environment: 0,
            structure: 0,
            legendary: 0,
            layout: array![].span(),
            entities: entity_data,
            affinity: 0,
            dungeon_name: array![].span()
        }
    }

    fn get_entities(token_id: u256) -> EntityData {
        // call contract may not be a good choice?
        // let seed: u256 = seeder::DungeonsSeeder::__wrapper_get_seed();
        let seed: u256 = 0;
        let (x_array, y_array, t_array) = generator::get_entities(seed, token_id);

        EntityData { x: x_array.span(), y: y_array.span(), entity_data: t_array.span() }
    }

    fn get_layout(seed: u256, size: u256, token_id: u256) -> (Span<u256>, u256) {
        let (mut layout, structure) = generator::get_layout(seed, size);

        let range = size * size / 256 + 1;
        let mut result: Array<u256> = ArrayTrait::new();
        let mut count = 0;
        loop {
            if count > range {
                break;
            }
            result.append(layout.select(count));
            count += 1;
        };

        (result.span(), structure)
    }
}

