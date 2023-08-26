#[starknet::contract]
mod Dungeons {
    use array::ArrayTrait;
    use starknet::ContractAddress;
    use openzeppelin::token::erc721::ERC721;

    #[derive(Drop, Serde)]
    struct EntityData {
        x: Array<u8>,
        y: Array<u8>,
        entityType: Array<u8>,
    }

    #[derive(Drop, Serde)]
    struct Dungeon {
        size: u8,
        environment: u8,
        structure: u8, // crypt or cavern
        legendary: u8,
        layout: felt252,
        entities: EntityData,
        affinity: felt252,
        dungeonName: felt252,
    }

    #[storage]
    struct Storage {
        token_id: u8,
        cc_name: felt252,
        tokenUri: felt252,
        svg: felt252
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_supply: u256, recipient: ContractAddress) {
        let name = 'MyNFT';
        let symbol = 'MNFT';

        let mut unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::InternalImpl::initializer(ref unsafe_state, name, symbol);
    }

    #[external(v0)]
    fn name(self: @ContractState) -> felt252 {
        let unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721MetadataImpl::name(@unsafe_state)
    }

    #[external(v0)]
    fn safe_mint(ref self: ContractState, to: ContractAddress, token_id: u256, data: Span<felt252>) {
        let mut unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::InternalImpl::_safe_mint(ref unsafe_state, to, token_id, data);
    }
}
