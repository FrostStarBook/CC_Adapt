use debug::PrintTrait;
use starknet::ContractAddress;


fn devide() -> u128 {
    let x: u128 = 1;
    let y: u128 = 2;

    x / y
}

fn devide_u64() -> u64 {
    let x: u64 = 1;
    let y: u64 = 2;

    x / y
}

fn devide2() -> u256 {
    let x: u256 = 1;
    let y: u256 = 2;

    x / y
}


#[test]
#[available_gas(30000)]
#[ignore]
fn it_works() {
    let result: u128 = devide();

    result.print();

    assert(result == 1, result.into());
}

#[test]
#[available_gas(30000)]
#[ignore]
fn it_works_u64() {
    let result: u64 = devide_u64();

    result.print();

    assert(result == 1, result.into());
}

#[test]
#[available_gas(30000)]
#[ignore]
fn it_works2() {
    let result: u256 = devide2();

    result.print();

    assert(result == 1, result.try_into().unwrap());
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
