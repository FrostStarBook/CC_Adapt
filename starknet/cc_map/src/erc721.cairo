#[starknet::contract]
mod MyToken {
    use starknet::ContractAddress;
    use openzeppelin::token::erc721::ERC721;

    #[storage]
    struct Storage {}

    #[constructor]
    fn constructor(ref self: ContractState, initial_supply: u256, recipient: ContractAddress) {
        let name = 'Crypts and Caverns';
        let symbol = 'C&C';

        let mut unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::InternalImpl::initializer(ref unsafe_state, name, symbol);
    }

    #[external(v0)]
    fn mint(ref self: ContractState, to: ContractAddress, token_id: u256, data: Span<felt252>) {
        let mut unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::InternalImpl::_safe_mint(ref unsafe_state, to, token_id, data)
    }
}
