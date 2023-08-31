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
    ) -> Array<felt252>;

    fn tokenURI(
        ref self: TContractState, tokenId: u256, dungeon: Dungeon, entities: Array<u256>
    ) -> Array<felt252>;
}

#[starknet::interface]
trait IDungeonsSeeder<TContractState> {
    fn get_seed(self: @TContractState, token_id: u256) -> u256;

    fn get_size(self: @TContractState, seed: u64) -> u8;

    fn get_environment(self: @TContractState, seed: u64) -> u8;

    fn get_name(self: @TContractState, seed: u128) -> (Array<felt252>, felt252, u8);
}
