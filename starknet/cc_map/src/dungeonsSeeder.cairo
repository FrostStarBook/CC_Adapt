use array::ArrayTrait;
use debug::PrintTrait;


fn main() {
    let mut prefixes = ArrayTrait::<felt252>::new();

    prefixes.append('Abyssal');
    prefixes.append('Ancient');
    prefixes.append('Bleak');
    prefixes.append('Bright');
    prefixes.append('Burning');
    prefixes.append('Collapsed');
    prefixes.append('Corrupted');
    prefixes.append('Dark');
    prefixes.append('Decrepid');
    prefixes.append('Desolate');
    prefixes.append('Dire');
    prefixes.append('Divine');
    prefixes.append('Emerald');
    prefixes.append('Empyrean');
    prefixes.append('Fallen');
    prefixes.append('Glowing');
    prefixes.append('Grim');
    prefixes.append('Heaven\'s');
    prefixes.append('Hidden');
    prefixes.append('Holy');
    prefixes.append('Howling');
    prefixes.append('Inner');
    prefixes.append('Morbid');
    prefixes.append('Murky');
    prefixes.append('Outer');
    prefixes.append('Shimmering');
    prefixes.append('Siren\'s');
    prefixes.append('Sunken');
    prefixes.append('Whispering');

    let first = *prefixes.at(0);
    let second = *prefixes.at(1);
    let second = *prefixes.at(17);

    first.print();
    second.print();
    'dungeonsSeeder.......'.print();
}
