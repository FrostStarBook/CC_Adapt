#[starknet::contract]
mod DungeonsGenerator {

    use starknet::ContractAddress;
    use openzeppelin::token::erc20::ERC20;
    
    use array::ArrayTrait;
    use debug::PrintTrait;

    #[storage]
    struct Storage {
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let mut _prefix: Array<felt252> = ArrayTrait::new();

        _prefix.append('Abyssal');

    }

    #[test]
    fn test(self: @ContractState) {}
}
