use core::array::{Array, ArrayTrait, Span, SpanTrait};
use box::BoxTrait;
use debug::PrintTrait;
use nullable::{NullableTrait, nullable_from_box, match_nullable, FromNullableResult};

use starknet::ContractAddress;
use openzeppelin::token::erc20::ERC20;
use cc_map::utils::random::{random_u128};
use cc_map::utils::bit_operation::{BitOperationTrait};

#[derive(Copy, Drop)]
struct Dungeon {
    size: u8,
    environment: u8,
    structure: u8,
    legendary: u8,
    layout: Span<(u8, u8)>,
    entities: EntityData,
    affinity: felt252,
    dungeon_name: Span<felt252>
}

#[derive(Copy, Drop)]
struct EntityData {
    x: Span<u8>,
    y: Span<u8>,
    entity_data: Span<u8>
}

#[derive(Copy, Drop, serded)]
struct Settings {
    size: u128,
    length: u128,
    seed: u128,
    counter: u128
}

#[derive(Copy, Drop)]
struct RoomSettings {
    min_rooms: u128,
    max_rooms: u128,
    min_room_size: u128,
    max_room_size: u128
}

#[derive(Copy, Drop)]
struct Room {
    x: u128,
    y: u128,
    width: u128,
    height: u128
}

fn random_with_counter_plus(ref settings: Settings, min: u128, max: u128) -> u128 {
    let result = random_u128(settings.seed + settings.counter, min, max);
    settings.counter += 1;
    result
}

fn get_length(size: u128) -> u128 {
    size * size / 256 + 1
}

fn add_mark(floor: Array<(u128, u128)>, hallways: Array<(u128, u128)>) -> Array<(u128, u128)> {
    floor
}

fn build_settings(seed: u128, size: u128) -> Settings {
    Settings { size: size, length: get_length(size), seed: seed, counter: 0 }
}

fn get_layout(seed: u128, size: u128) -> (Array<(u128, u128)>, u128) {
    let mut settings: Settings = build_settings(seed, size);

    let mut structure: u128 = 0;
    if random_u128(seed.left_shift(0), 0, 100) > 30 {
        {}
    //    let (mut rooms:Array<Rooms>,mut floor:Array<(u128,u128)>) = generate_rooms(settings);
    //    let mut hallways:Array<(u128,u128)> = generate_hallways(settings,rooms);

    // (add_mark(ref floor, hallways), structure)
    } else {
        structure = 1;
    // let mut cavern:Array<(u128,u128)> = generate_cavern(settings);
    // (cavern, structure)
    }
    (ArrayTrait::new(), structure)
}

fn get_entities(seed: u128, size: u128) -> (Array<u128>, Array<u128>, Array<u128>) {
    // let (mut points:Array<(u128,u128)>,mut doors:Array<(u128,u128)>) = generate_entities(seed,size);
    // parse_entities(size,points,doors)
    (ArrayTrait::new(), ArrayTrait::new(), ArrayTrait::new())
}

fn get_points(seed: u128, size: u128) -> (Array<(u128, u128)>, u128) {
    // let mut (mut points:Array<(u128,u128)>,) = generate_entities(seed,size);
    // (points, points.len())
    (ArrayTrait::new(), 0)
}

fn get_doors(seed: u128, size: u128) -> (Array<(u128, u128)>, u128) {
    // let (,mut doors:Array<(u128,u128)>) = generate_entities(seed,size);
    // (doors, doors.len())
    (ArrayTrait::new(), 0)
}

fn square_root(origin: u128) -> u128 {
    let mut x = origin;
    let mut y = (x + 1) / 2;

    loop {
        if y >= x {
            break;
        }
        x = y;
        y = (origin / y + y) / 2;
    };

    return x;
}

fn generate_entities(seed: u128, size: u128) -> (Array<(u128, u128)>, Array<(u128, u128)>) {
    let mut settings: Settings = build_settings(seed, size);

    if random_u128(settings.seed + settings.counter, 0, 100) > 30 {
        settings.counter += 1;

        //    let (mut rooms:Array<(u128, u128)>, mut floor:Array<(u128, u128)>) = generate_rooms(settings);

        //    let mut hallways:Array<(u128, u128)> = generate_hallways(settings, rooms);

        //    // hallways does not take the bit which floor had mark already

        //    let mut hallways_points:Array<(u128, u128)> = if hallways.len() > 0 {
        //     generate_points(settings,hallways,40/square_root(hallways.len()))
        //    }else{
        //        array![]
        //    }
        //    (generate_points(settings,floor, 12/square_root(settings.size - 6)), hallways_points)

        (ArrayTrait::new(), ArrayTrait::new())
    } else {
        settings.counter += 1;

        // let mut cavern:Array<(u128, u128)> = generate_cavern(settings);
        // let mut points:Array<(u128,u128)> = generate_points(settings,cavern,12/square_root(cavern.len()-6));
        // let mut doors:Array<(u128,u128)> = generate_points(settings,cavern,40/square_root(cavern.len()));

        // // the points does not take the bit which floor had mark already
        // (points,doors)

        (ArrayTrait::new(), ArrayTrait::new())
    }
}

fn generate_new_room(ref settings: Settings, room_settings: @RoomSettings) -> Room {
    let min_room_size = *room_settings.min_room_size;
    let max_room_size = *room_settings.max_room_size;

    let width = random_u128(settings.seed + settings.counter, min_room_size, max_room_size);
    settings.counter += 1;
    let height = random_u128(settings.seed + settings.counter, min_room_size, max_room_size);
    settings.counter += 1;
    let x = random_u128(settings.seed + settings.counter, 1, settings.size - 1 - width);
    settings.counter += 1;
    let y = random_u128(settings.seed + settings.counter, 1, settings.size - 1 - height);
    settings.counter += 1;

    Room { x: x, y: y, width: width, height: height }
}

fn is_valid_room(rooms: @Array<Room>, num_rooms: u128, current: @Room) -> bool {
    let rooms_span = rooms.span();
    let length: u128 = rooms_span.len().into();
    if length > 0 {
        let mut i = 0;
        loop {
            if i == length - num_rooms {
                break true;
            }

            let room: Room = *rooms_span.at(i.try_into().expect('out of bounds'));
            if (room.x - 1 < *current.x + *current.width)
                && (room.x + room.width + 1 > *current.x)
                && (room.y - 1 < *current.x + *current.height)
                && (room.y + room.height > *current.y) {
                break false;
            }

            i += 1;
        }
    } else {
        true
    }
}

fn append_room_and_floor(ref rooms: Array<Room>, ref floor: Array<(u128, u128)>, current: Room) {
    rooms.append(current);

    let mut y = current.y;
    loop {
        if y == current.y + current.height {
            break;
        }

        let mut x = current.x;
        loop {
            if x == current.x + current.width {
                break;
            }

            floor.append((x, y));

            x += 1;
        };

        y += 1;
    };
}

fn generate_rooms(ref settings: Settings) -> (Array<Room>, Array<(u128, u128)>) {
    let mut room_settings: RoomSettings = RoomSettings {
        min_rooms: settings.size / 3,
        max_rooms: settings.size,
        min_room_size: 2,
        max_room_size: settings.size / 3
    };

    let mut rooms: Array<Room> = ArrayTrait::new();
    let mut floor: Array<(u128, u128)> = ArrayTrait::new();

    let mut num_rooms = random_u128(
        settings.seed + settings.counter, room_settings.min_rooms, room_settings.max_rooms
    );
    settings.counter += 1;

    let mut safety_check: u128 = 256;
    loop {
        let current: Room = generate_new_room(ref settings, @room_settings);

        let valid: bool = is_valid_room(@rooms, num_rooms, @current);
        if valid {
            append_room_and_floor(ref rooms, ref floor, current);
            num_rooms -= 1;
        }

        if safety_check == 0 {
            break;
        }
        safety_check -= 1;
    };

    (rooms, floor)
}

#[derive(Copy, Drop)]
enum Direction {
    LEFT,
    UP,
    RIGHT,
    DOWN,
}

fn get_direction(base_x: u128, base_y: u128, direction: Direction) -> (u128, u128) {
    match direction {
        Direction::LEFT => (base_x - 1, base_y),
        Direction::UP => (base_x, base_y - 1),
        Direction::RIGHT => (base_x + 1, base_y),
        Direction::DOWN => (base_x, base_y + 1),
    }
}

// fn left_direction(ref settings:Settings) -> Direction {
//     let direction: u128 = random_u128(settings.seed.left_shift(settings.counter), 1, 4);
//     settings.counter +=1;

//     if direction == 0 {
//         Direction::LEFT
//     } else if direction == 1 {
//         Direction::UP
//     } else if direction == 2 {
//         Direction::RIGHT
//     } else {
//         Direction::DOWN
//     }
// }

fn is_left(direction: Direction) -> bool {
    match direction {
        Direction::LEFT => true,
        Direction::UP => false,
        Direction::RIGHT => false,
        Direction::DOWN => false,
    }
}

fn clockwise_rotation(direction: Direction) -> Direction {
    match direction {
        Direction::LEFT => {
            Direction::UP
        },
        Direction::UP => {
            Direction::RIGHT
        },
        Direction::RIGHT => {
            Direction::DOWN
        },
        Direction::DOWN => {
            Direction::LEFT
        }
    }
}

fn counterclockwise_rotation(direction: Direction) -> Direction {
    match direction {
        Direction::LEFT => {
            Direction::DOWN
        },
        Direction::UP => {
            Direction::LEFT
        },
        Direction::RIGHT => {
            Direction::UP
        },
        Direction::DOWN => {
            Direction::RIGHT
        }
    }
}

fn generate_direction(ref settings: Settings) -> Direction {
    let direction: u128 = random_u128(settings.seed.left_shift(settings.counter), 1, 4);
    settings.counter += 1;

    if direction == 0 {
        Direction::LEFT
    } else if direction == 1 {
        Direction::UP
    } else if direction == 2 {
        Direction::RIGHT
    } else {
        Direction::DOWN
    }
}

fn generate_cavern(ref settings: Settings) -> Array<(u128, u128)> {
    let holes = settings.size / 2;

    let mut i = 0;
    let mut cavern: Array<(u128, u128)> = ArrayTrait::new();
    loop {
        if i == holes {
            break;
        }

        let x = random_u128(settings.seed.left_shift(settings.counter), 0, 100);
        settings.counter += 1;
        let y = random_u128(settings.seed.left_shift(settings.counter), 0, 100);
        settings.counter += 1;

        let mut last_direction: Direction = Direction::LEFT;
        let mut next_direction: Direction = Direction::LEFT;
        loop {
            cavern.append((x, y));

            if is_left(last_direction) {
                let next_direction = generate_direction(ref settings);
                last_direction = next_direction;
            } else {
                let mut direction_seed: u128 = random_u128(
                    settings.seed.left_shift(settings.counter), 0, 100
                );
                settings.counter += 1;

                if direction_seed <= 25 {
                    next_direction = clockwise_rotation(last_direction);
                } else if direction_seed <= 50 {
                    next_direction = counterclockwise_rotation(last_direction);
                } else {
                    next_direction = last_direction;
                }
            }

            if !(x > 0 && y > 0 && x < settings.size && y < settings.size) {
                break;
            }
            let (x, y) = get_direction(x, y, next_direction);
        };

        i += 1;
    };

    cavern
}

fn connect_halls_vertical(
    ref hallways: Array<(u128, u128)>, x: u128, current_y: u128, previous_y: u128
) {
    let mut min: u128 = if current_y > previous_y {
        previous_y
    } else {
        current_y
    };
    let mut max: u128 = if current_y > previous_y {
        current_y
    } else {
        previous_y
    };
    let mut y = min;
    loop {
        if y == max {
            break;
        }
        hallways.append((x, y));
        y += 1;
    };
}

fn connect_halls_horizontal(
    ref hallways: Array<(u128, u128)>, current_x: u128, previous_x: u128, y: u128
) {
    let mut min: u128 = if current_x > previous_x {
        previous_x
    } else {
        current_x
    };
    let mut max: u128 = if current_x > previous_x {
        current_x
    } else {
        previous_x
    };
    let mut x = min;
    loop {
        if x == max {
            break;
        }
        hallways.append((x, y));
        x += 1;
    }
}

fn generate_hallways(ref settings: Settings, rooms: @Array<Room>) -> Array<(u128, u128)> {
    let mut hallways: Array<(u128, u128)> = ArrayTrait::new();

    let rooms_span = rooms.span();

    if !rooms_span.is_empty() {
        let mut previous_x: u128 = *rooms_span.at(0).x + (*rooms_span.at(0).width / 2);
        let mut previous_y: u128 = *rooms_span.at(0).y + (*rooms_span.at(0).height / 2);

        let mut i = 1;
        loop {
            if i == rooms_span.len() {
                break;
            }

            let mut current_x = *rooms_span.at(i).x + (*rooms_span.at(i).width / 2);
            let mut current_y = *rooms_span.at(i).y + (*rooms_span.at(i).height / 2);

            if current_x == previous_x {
                connect_halls_vertical(ref hallways, current_x, previous_x, current_y);
            } else if current_y == previous_y {
                connect_halls_horizontal(ref hallways, current_x, current_y, previous_y);
            } else {
                if random_with_counter_plus(ref settings, 1, 2) == 2 {
                    connect_halls_horizontal(ref hallways, current_x, previous_x, current_y);
                    connect_halls_vertical(ref hallways, current_x, current_y, previous_y);
                } else {
                    connect_halls_vertical(ref hallways, current_x, previous_x, current_y);
                    connect_halls_horizontal(ref hallways, current_x, current_y, previous_y);
                }
            }

            previous_x = current_x;
            previous_y = current_y;

            i += 1;
        };
    }

    hallways
}


fn generate_points(
    ref settings: Settings, ref map: Array<(u128, u128)>, probability: u128
) -> Array<(u128, u128)> {
    let mut points: Array<(u128, u128)> = ArrayTrait::new();

    let mut prob: u128 = random_with_counter_plus(ref settings, 0, probability);
    if (prob == 0) {
        prob = 1;
    }

    let mut counter = 0;
    loop {
        if counter == 1 {
            break;
        }
        // maybe should build a dict for indexing '1' in map when generate_something() running
        // anyway deadline is the most powerful thing

        let mut count = 0;
        // loop{loop{loop{}}};

        counter += 1;
    };

    points
}

#[cfg(test)]
mod tests {
    use core::traits::{Into, TryInto};
    use core::option::OptionTrait;
    use core::array::ArrayTrait;
    use core::array::SpanTrait;
    use core::dict::Felt252DictTrait;
    use core::dict::Felt252DictEntryTrait;
    use box::BoxTrait;
    use debug::PrintTrait;
    use nullable::{NullableTrait, nullable_from_box, match_nullable, FromNullableResult};

    use starknet::ContractAddress;
    use openzeppelin::token::erc20::ERC20;

    #[test]
    #[ignore]
    #[available_gas(300000000000000)]
    fn test_generate_room() {}
}
