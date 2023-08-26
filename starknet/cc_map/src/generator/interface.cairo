use super::dungeons_generator::DungeonsGenerator::{Settings};


#[starknet::interface]
trait IDungeonsGenerator<TContractState> {
    // for example
    // fn generate_rooms(ref self: TContractState, settings: Settings);
}
