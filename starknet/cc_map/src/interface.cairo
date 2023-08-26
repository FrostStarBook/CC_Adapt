use array::ArrayTrait;
use cc_map::dungeons::Dungeons::Dungeon;

// TODO
// #[starknet::interface]
// trait IDungeons<TContractState> { 
// }

#[starknet::interface]
trait IDungeonsRender<TContractState> {
    fn draw(
        ref self: TContractState,
        dungeon: Dungeon,
        x: Array<u8>,
        y: Array<u8>,
        entityData: Array<u8>
    ) -> felt252;
    fn tokenURI(
        ref self: TContractState, tokenId: u256, dungeon: Dungeon, entities: Array<u256>
    ) -> felt252;
}
