use debug::PrintTrait;
use starknet::ContractAddress;


fn function() {
    let mut i: u128 = 1;
    let mut j: u128 = 2;
    {
        i = 3;
        j = i;
    }
    i.print();
    j.print();
}

#[test]
#[ignore]
#[available_gas(30000000)]
fn test() {
    function();
}
