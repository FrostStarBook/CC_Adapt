/// Array contains sets of 4 colors:
/// 0 = bg, 1 = wall, 2 = door, 3 = point
/// To calculate, multiply environment (int 0-5) by 4 and add the above numbers.
mod Colors {
    // Desert
    const ZERO: felt252 = 'F3D899';
    const ONE: felt252 = '160F09';
    const TWO: felt252 = 'FAAA00';
    const THREE: felt252 = '00A29D';
    // Stone Temple
    const FOUR: felt252 = '967E67';
    const FIVE: felt252 = 'F3D899';
    const SIX: felt252 = '3C2A1A';
    const SEVEN: felt252 = '006669';
// TODO 
// Forest Ruins
// Mountain Deep
// Underwater Keep
// Ember"s Glow
}

/// Names mapped to the above colors
mod EnvironmentName {
    const ZERO: felt252 = 'Desert Oasis';
    const ONE: felt252 = 'Stone Temple';
    const TWO: felt252 = 'Forest Ruins';
    const THREE: felt252 = 'Mountain Deep';
    const FOUR: felt252 = 'Underwater Keep';
    // TODO Ember's Glow
    const FIVE: felt252 = 'Embers Glow';
}
