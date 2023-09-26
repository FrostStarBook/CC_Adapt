#[starknet::contract]
mod test {
    #[storage]
    struct Storage {}

    #[constructor]
    fn constructor(self: @ContractState) {}


    #[external(v0)]
    fn external(self: @ContractState) -> ByteArray {
        let mut arr: ByteArray = Default::default();
        arr.append_byte('a');
        arr
    }
}
