#[starknet::contract]
mod Dungeons {
    use starknet::ContractAddress;
    use openzeppelin::token::erc721::ERC721;
    use openzeppelin::security::reentrancyguard::ReentrancyGuard;
    use cc_map::dungeons_generator as generator;

    // ------------------------------------------- Structs -------------------------------------------

    // #[derive(Copy, Drop)]
    // struct Dungeon {
    //     size: u8,
    //     environment: u8,
    //     structure: u8,
    //     legendary: u8,
    //     layout: Span<(u8, u8)>,
    //     entities: EntityData,
    //     affinity: felt252,
    //     dungeon_name: Span<felt252>
    // }

    // #[derive(Copy, Drop)]
    // struct EntityData {
    //     x: Span<u8>,
    //     y: Span<u8>,
    //     entity_data: Span<u8>
    // }

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
        seeds: LegacyMap::<u256, u256>,
        // loot:ContractAddress,
        last_mint: u256,
        claimed: u256,
        restructed: bool,
    // price: u256,
    }

    // ------------------------------------------ Constructor ------------------------------------------

    #[constructor]
    fn constructor(ref self: ContractState) {
        let mut unsafe_new_contract_state = ERC721::unsafe_new_contract_state();
    }

    // ------------------------------------------- Functions -------------------------------------------

    #[external(v0)]
    fn claim(ref self: ContractState, token_id: u256) {}
}
