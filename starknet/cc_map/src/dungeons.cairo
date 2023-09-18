#[starknet::contract]
mod Dungeons {
    use array::ArrayTrait;
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
    struct Storage {}
}
