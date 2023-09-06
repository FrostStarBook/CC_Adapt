#[starknet::contract]
mod example {
    use dict::Felt252DictTrait;
    use dict::Felt252DictEntryTrait;
    use debug::PrintTrait;

    #[storage]
    struct Storage {}

    fn test() {
        let mut dict: Felt252Dict<u8> = Default::default();

        custom_insert(ref dict, '0', 100);

        let val = custom_get(ref dict, '0');

        assert(val == 100, 'Expecting 100');

        let mut dic: Felt252Dict<Nullable<Array<u8>>> = Default::default();

        // dic.squash();
    }


    fn custom_insert<
        T,
        impl TDefault: Felt252DictValue<T>,
        impl TDestruct: Destruct<T>,
        impl TDrop: Drop<T>
    >(
        ref dict: Felt252Dict<T>, key: felt252, value: T
    ) {
        // Get the last entry associated with `key`
        // Notice that if `key` does not exists, _prev_value will
        // be the default value of T.
        let (entry, _prev_value) = dict.entry(key);

        // Insert `entry` back in the dictionary with the updated value,
        // and recieve ownership of the dictionary
        dict = entry.finalize(value);
    }

    fn custom_get<T, impl TDefault: Felt252DictValue<T>, impl TDrop: Drop<T>, impl TCopy: Copy<T>>(
        ref dict: Felt252Dict<T>, key: felt252
    ) -> T {
        // Get the new entry and the previous value held at `key`
        let (entry, prev_value) = dict.entry(key);

        // Store the value to return
        let return_value = prev_value;

        // Update the entry with `prev_value` and get back ownership of the dictionary
        dict = entry.finalize(prev_value);

        // Return the read value
        return_value
    }
}

use array::{ArrayTrait, SpanTrait};
use box::BoxTrait;
use dict::Felt252DictTrait;
use nullable::{NullableTrait, nullable_from_box, match_nullable, FromNullableResult};

fn main() {
    // Create the dictionary
    let mut d: Felt252Dict<Nullable<Span<felt252>>> = Default::default();

    // Crate the array to insert
    let mut a = ArrayTrait::new();
    a.append(8);
    a.append(9);
    a.append(10);

    // Insert it as a `Span`
    d.insert(0, nullable_from_box(BoxTrait::new(a.span())));

    // Get value back
    let val = d.get(0);

    // Search the value and assert it is not null
    let span = match match_nullable(val) {
        FromNullableResult::Null(()) => panic_with_felt252('No value found'),
        FromNullableResult::NotNull(val) => val.unbox(),
    };

    // Verify we are having the right values
    assert(*span.at(0) == 8, 'Expecting 8');
    assert(*span.at(1) == 9, 'Expecting 9');
    assert(*span.at(2) == 10, 'Expecting 10');
}
