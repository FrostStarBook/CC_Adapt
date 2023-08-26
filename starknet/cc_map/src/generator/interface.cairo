#[starknet::interface]
trait IDungeonsGenerator {
    fn generate_rooms(ref self: ContractState, settings: Settings);
}