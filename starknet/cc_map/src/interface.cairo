use array::ArrayTrait;
use cc_map::dungeons::Dungeons::{Dungeon, EntityData};

// TODO
// #[starknet::interface]
// trait IDungeons<TContractState> { 
// }

#[starknet::interface]
trait IDungeonsRender<TContractState> {
    fn draw(
        ref self: TContractState,
        dungeon: Dungeon,
        x: Span<u8>,
        y: Span<u8>,
        entity_data: Span<u8>
    ) -> Array<felt252>;

    fn tokenURI(
        ref self: TContractState, tokenId: u256, dungeon: Dungeon, entities: EntityData
    ) -> Array<felt252>;
}

#[starknet::interface]
trait IDungeonsSeeder<TContractState> {
    fn get_seed(self: @TContractState, token_id: u256) -> u256;

    fn get_size(self: @TContractState, seed: u256) -> u8;

    fn get_environment(self: @TContractState, seed: u256) -> u8;

    fn get_name(self: @TContractState, seed: u256) -> (Array<felt252>, felt252, u8);
}
