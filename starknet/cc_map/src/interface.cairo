use array::ArrayTrait;

#[derive(Copy, Drop)]
struct EntityData {
    x: Array<u8>,
    y: Array<u8>,
    entityType: Array<u8>,
}

#[derive(Copy, Drop)]
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

#[starknet::interface]
trait IDungeons<TContractState> { // TODO
}

#[starknet::interface]
trait IDungeonsRender<TContractState> {
    fn draw(
        ref self: ContractState, dungeon: Dungeon, x: Array<u8>, y: Array<u8>, entityData: Array<u8>
    ) -> felt252;
    fn tokenURI(
        ref self: ContractState, tokenId: u256, dungeon: Dungeon, entities: Array<u256>
    ) -> felt252;
}
