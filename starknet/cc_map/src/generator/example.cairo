use debug::PrintTrait;
use starknet::ContractAddress;


#[view]
fn devide() -> u128 {
    let x: u128 = 99;
    let y: u128 = 50;

    x / y
}


#[test]
#[available_gas(30000)]
fn it_works() {
    let result: u128 = devide();

    result.print();

    assert(result == 1, '');
}

#[derive(starknet::Event)]
struct Transfer {
    #[key]
    from: ContractAddress,
    #[key]
    to: ContractAddress,
    amount: u256
}

#[derive(starknet::Event)]
struct Approve {
    #[key]
    owner: ContractAddress,
    #[key]
    spender: ContractAddress,
    amount: u256
}

#[event]
#[derive(starknet::Event)]
enum Event {
    Transfer: Transfer,
    Approve: Approve
}
