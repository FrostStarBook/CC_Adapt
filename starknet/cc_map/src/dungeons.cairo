#[starknet::contract]
mod Dungeons {
    use array::ArrayTrait;

    #[derive(Copy, Drop, Serde)]
    struct EntityData {
        x: Span<u8>,
        y: Span<u8>,
        entity_data: Span<u8>
    }

    #[derive(Copy, Drop, Serde)]
    struct Dungeon {
        size: u8,
        environment: u8,
        structure: u8,
        legendary: u8,
        layout: Span<(u8, u8)>,
        entities: EntityData,
        affinity: felt252,
        dungeon_name: Span<felt252>
    }

    #[storage]
    struct Storage {}
}
