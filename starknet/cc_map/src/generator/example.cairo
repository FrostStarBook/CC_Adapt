use debug::PrintTrait;

// just for test

fn function() {

}

#[test]
#[ignore]
#[available_gas(30000000)]
fn test() {
    function();
}
