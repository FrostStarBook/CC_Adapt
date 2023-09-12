use debug::PrintTrait;

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

