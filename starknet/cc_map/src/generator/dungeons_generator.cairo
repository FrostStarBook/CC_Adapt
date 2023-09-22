use core::array::{Array, ArrayTrait, Span, SpanTrait};
use box::BoxTrait;
use debug::PrintTrait;
use nullable::{NullableTrait, FromNullableResult, nullable_from_box, match_nullable};
use starknet::ContractAddress;
use openzeppelin::token::erc20::ERC20;
use cc_map::utils::random::{random};
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
    size: u256,
    length: u256,
    seed: u256,
    counter: u256
}

#[derive(Copy, Drop)]
struct RoomSettings {
    min_rooms: u256,
    max_rooms: u256,
    min_room_size: u256,
    max_room_size: u256
}

#[derive(Copy, Drop)]
struct Room {
    x: u256,
    y: u256,
    width: u256,
    height: u256
}

// cause some annoying errors
// #[derive(Copy, Drop)]
// enum Direction {
//     LEFT,
//     UP,
//     RIGHT,
//     DOWN,
// }

// ------------------------------------------- MapTrait -------------------------------------------

#[generate_trait]
impl MapImpl of MapTrait {
    fn select(ref self: Felt252Dict<Nullable<u256>>, key: u256) -> u256 {
        // implement the zero_default may be good too
        match match_nullable(self.get(key.try_into().expect('invalid key'))) {
            FromNullableResult::Null(()) => {
                self.update(key, 0);
                0
            },
            FromNullableResult::NotNull(val) => val.unbox()
        }
    }

    fn update(ref self: Felt252Dict<Nullable<u256>>, key: u256, value: u256) {
        self.insert(key.try_into().expect('invalid key'), nullable_from_box(BoxTrait::new(value)));
    }

    fn set_bit(ref self: Felt252Dict<Nullable<u256>>, position: u256) {
        let quotient = position / 256;
        let remainder = position % 256;

        self.update(quotient, (self.select(quotient)) | (1.left_shift(255 - remainder)));
    }

    fn get_bit(ref self: Felt252Dict<Nullable<u256>>, position: u256) -> u256 {
        let quotient = position / 256;
        let remainder = position % 256;

        self.select(quotient).right_shift(255 - remainder) & 1
    }

    fn add_bit(
        ref self: Felt252Dict<Nullable<u256>>, ref other: Felt252Dict<Nullable<u256>>, length: u256
    ) {
        let mut limit: u256 = length;
        loop {
            if limit == 0 {
                break;
            }
            let key = limit - 1;
            self.update(key, (self.select(key) | (other.select(key))));
            limit -= 1;
        }
    }

    fn subtract_bit(
        ref self: Felt252Dict<Nullable<u256>>, ref other: Felt252Dict<Nullable<u256>>, length: u256
    ) {
        let mut limit: u256 = length;
        loop {
            if limit == 0 {
                break;
            }
            let key = limit - 1;
            self.update(key, (self.select(key) & ~(other.select(key))));
            limit -= 1;
        }
    }

    fn count_bit(ref self: Felt252Dict<Nullable<u256>>, length: u256) -> u256 {
        let mut length = length;
        let mut result = 0;
        loop {
            if length == 0 {
                break;
            }
            let key = length - 1;
            let mut value: u256 = self.select(key);
            loop {
                if value == 0 {
                    break;
                }
                value = value & (value - 1);
                result += 1;
            };
            length -= 1;
        };
        result
    }
}


#[test]
#[ignore]
#[available_gas(30000000)]
fn testset() {
    let mut map: Felt252Dict<Nullable<u256>> = Default::default();
    map.set_bit(341);
    'map(1)'.print();
    map.select(1).print();
}

#[test]
#[ignore]
#[available_gas(30000000)]
fn test_set_bit() {
    let mut map: Felt252Dict<Nullable<u256>> = Default::default();
    let key = 0;
    // for test only, it won't be used this way
    map.update(key, 2);
    map.set_bit(20);
    assert(map.select(key) == 1048578, 'set bit');
    assert(map.get_bit(19) == 0, 'get bit of index 19');
    assert(map.get_bit(20) == 1, 'get bit of index 20');
    assert(map.count_bit(1) == 2, 'count bit');

    let mut another_map: Felt252Dict<Nullable<u256>> = Default::default();
    // for test only, it won't be used this way
    another_map.update(key, 3);
    another_map.set_bit(30);
    assert(another_map.count_bit(1) == 3, 'count bit');

    map.add_bit(ref another_map, 1);
    assert(map.count_bit(1) == 4, 'add bit');
    map.subtract_bit(ref another_map, 1);
    assert(map.count_bit(1) == 1, 'subtract bit');
}

// ------------------------------------------- Generator -------------------------------------------

fn get_layout(seed: u256, size: u256) -> (Felt252Dict<Nullable<u256>>, u256) {
    let mut settings: Settings = build_settings(seed, size);
    let mut structure: u256 = 0;

    if random_shift_counter_plus(ref settings, 0, 100) > 30 {
        let (mut rooms, mut floor) = generate_rooms(ref settings);
        let mut hallways = generate_hallways(ref settings, @rooms);
        floor.add_bit(ref hallways, settings.length);
        (floor, structure)
    } else {
        structure = 1;
        let cavern: Felt252Dict = generate_cavern(ref settings);
        (cavern, structure)
    }
}

fn generate_rooms(ref settings: Settings) -> (Array<Room>, Felt252Dict<Nullable<u256>>) {
    'generate_rooms'.print();
    let mut room_settings: RoomSettings = RoomSettings {
        min_rooms: settings.size / 3,
        max_rooms: settings.size,
        min_room_size: 2,
        max_room_size: settings.size / 3
    };

    let mut rooms: Array<Room> = ArrayTrait::new();
    let mut floor: Felt252Dict<Nullable<u256>> = Default::default();

    let mut num_rooms = random_with_counter_plus(
        ref settings, room_settings.min_rooms, room_settings.max_rooms
    );

    let mut safety_check: u128 = 256;
    loop {
        if num_rooms == 0 {
            break;
        }

        let current: Room = generate_new_room(ref settings, @room_settings);

        if is_valid_room(@rooms, @current) {
            rooms.append(current);
            mark_the_floor(ref floor, current, settings.size);
            num_rooms -= 1;
        }

        if safety_check == 0 {
            break;
        }
        safety_check -= 1;
    };

    (rooms, floor)
}


fn explore_in_cavern(
    ref settings: Settings,
    ref cavern: Felt252Dict<Nullable<u256>>,
    ref last_direction: u8,
    ref next_direction: u8,
    mut x: u256,
    mut y: u256
) {
    cavern.set_bit(y * settings.size + x);

    if is_left(last_direction) {
        let new_direction = generate_direction(ref settings);
        last_direction = new_direction;
        next_direction = new_direction;
    } else {
        let direction_seed = random_shift_counter_plus(ref settings, 0, 100);
        if direction_seed <= 25 {
            next_direction = clockwise_rotation(last_direction);
        } else if direction_seed <= 50 {
            next_direction = counterclockwise_rotation(last_direction);
        } else {
            next_direction = last_direction;
        }
    }

    let (next_x, next_y) = get_direction(x, y, next_direction);
    x = next_x;
    y = next_y;

    if (x > 0 && x < settings.size && y > 0 && y < settings.size) {
        explore_in_cavern(ref settings, ref cavern, ref last_direction, ref next_direction, x, y);
    }
}

fn generate_cavern(ref settings: Settings) -> Felt252Dict<Nullable<u256>> {
    'generate_cavern'.print();
    let holes = settings.size / 2;
    let mut cavern: Felt252Dict<Nullable<u256>> = Default::default();
    let mut last_direction: u8 = 0;
    let mut next_direction: u8 = 0;

    let mut i = 0;
    loop {
        if i == holes {
            break;
        }

        let mut x = random_shift_counter_plus(ref settings, 0, settings.size);
        let mut y = random_shift_counter_plus(ref settings, 0, settings.size);

        explore_in_cavern(ref settings, ref cavern, ref last_direction, ref next_direction, x, y);

        i += 1;
    };

    cavern
}

fn generate_hallways(ref settings: Settings, rooms: @Array<Room>) -> Felt252Dict<Nullable<u256>> {
    'generate_hallways'.print();
    let mut hallways: Felt252Dict<Nullable<u256>> = Default::default();

    let rooms_span = rooms.span();

    if !rooms_span.is_empty() {
        let mut previous_x: u256 = *rooms_span.at(0).x + (*rooms_span.at(0).width / 2);
        let mut previous_y: u256 = *rooms_span.at(0).y + (*rooms_span.at(0).height / 2);

        let mut i = 1;
        loop {
            if i == rooms_span.len() {
                break;
            }

            let mut current_x = *rooms_span.at(i).x + (*rooms_span.at(i).width / 2);
            let mut current_y = *rooms_span.at(i).y + (*rooms_span.at(i).height / 2);

            if current_x == previous_x {
                connect_halls_vertical(
                    ref hallways, current_x, previous_x, current_y, settings.size
                );
            } else if current_y == previous_y {
                connect_halls_horizontal(
                    ref hallways, current_x, current_y, previous_y, settings.size
                );
            } else {
                if random_with_counter_plus(ref settings, 1, 2) == 2 {
                    connect_halls_horizontal(
                        ref hallways, current_x, previous_x, current_y, settings.size
                    );
                    connect_halls_vertical(
                        ref hallways, previous_y, current_y, current_x, settings.size
                    );
                } else {
                    connect_halls_vertical(
                        ref hallways, current_y, previous_y, previous_x, settings.size
                    );
                    connect_halls_horizontal(
                        ref hallways, previous_x, current_x, current_y, settings.size
                    );
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
    ref settings: Settings, ref map: Felt252Dict<Nullable<u256>>, probability: u256
) -> Felt252Dict<Nullable<u256>> {
    'generate_points'.print();
    let mut points: Felt252Dict<Nullable<u256>> = Default::default();

    // maintain consistency with the source code
    let mut prob: u256 = random_with_counter_plus(ref settings, 0, probability);
    if (prob == 0) {
        prob = 1;
    }

    let mut counter: u256 = 0;
    let limit: u256 = settings.size * settings.size;
    loop {
        if counter == limit {
            break;
        }

        if map.get_bit(counter) == 1 && random_with_counter_plus(ref settings, 0, 100) <= prob {
            points.set_bit(counter);
        }

        counter += 1;
    };

    points
}

fn get_entities(seed: u256, size: u256) -> (Array<u256>, Array<u256>, Array<u256>) {
    let (mut points, mut doors) = generate_entities(seed, size);
    parse_entities(size, ref points, ref doors)
}

fn parse_entities(
    size: u256, ref points: Felt252Dict<Nullable<u256>>, ref doors: Felt252Dict<Nullable<u256>>
) -> (Array<u256>, Array<u256>, Array<u256>) {
    let mut x_arr: Array<u256> = ArrayTrait::new();
    let mut y_arr: Array<u256> = ArrayTrait::new();
    let mut entity_type: Array<u256> = ArrayTrait::new();

    // let mut entity_count: u256 = points.count_bit(get_length(size))
    // + doors.count_bit(get_length(size));
    let mut counter: u256 = 0;

    let mut y: u256 = 0;
    loop {
        if y == size {
            break;
        }
        let mut x: u256 = 0;
        loop {
            if x == size {
                break;
            }

            if doors.get_bit(counter) == 1 {
                x_arr.append(x);
                y_arr.append(y);
                entity_type.append(0);
            }
            if points.get_bit(counter) == 1 {
                x_arr.append(x);
                y_arr.append(y);
                entity_type.append(1);
            }
            counter += 1;

            x += 1;
        };
        y += 1;
    };

    (x_arr, y_arr, entity_type)
}

fn get_points(seed: u256, size: u256) -> (Felt252Dict<Nullable<u256>>, u256) {
    let (mut points, mut doors) = generate_entities(seed, size);
    (points, points.count_bit(get_length(size)))
}

fn get_doors(seed: u256, size: u256) -> (Felt252Dict<Nullable<u256>>, u256) {
    let (mut points, mut doors) = generate_entities(seed, size);
    (doors, doors.count_bit(get_length(size)))
}

fn generate_entities(
    seed: u256, size: u256
) -> (Felt252Dict<Nullable<u256>>, Felt252Dict<Nullable<u256>>) {
    'generate_entities'.print();
    let mut settings: Settings = build_settings(seed, size);

    if random_with_counter_plus(ref settings, 0, 100) > 30 {
        let (mut rooms, mut floor) = generate_rooms(ref settings);

        let mut hallways = generate_hallways(ref settings, @rooms);

        // hallways does not take the bit which floor had mark already
        hallways.subtract_bit(ref floor, settings.length);

        let hallways_points: Felt252Dict<Nullable<u256>> = if hallways
            .count_bit(settings.length) > 0 {
            generate_points(
                ref settings, ref hallways, 40 / square_root(hallways.count_bit(settings.length))
            )
        } else {
            Default::default()
        };

        (
            generate_points(ref settings, ref floor, 12 / square_root(settings.size - 6)),
            hallways_points
        )
    } else {
        let mut cavern: Felt252Dict<Nullable<u256>> = generate_cavern(ref settings);
        let num_tiles: u256 = cavern.count_bit(settings.length);

        let mut points: Felt252Dict<Nullable<u256>> = generate_points(
            ref settings, ref cavern, 12 / square_root(num_tiles - 6)
        );
        let mut doors: Felt252Dict<Nullable<u256>> = generate_points(
            ref settings, ref cavern, 40 / square_root(num_tiles)
        );

        points.subtract_bit(ref doors, settings.length);

        (points, doors)
    }
}

fn generate_new_room(ref settings: Settings, room_settings: @RoomSettings) -> Room {
    let min_room_size = *room_settings.min_room_size;
    let max_room_size = *room_settings.max_room_size;

    let width = random_with_counter_plus(ref settings, min_room_size, max_room_size);
    let height = random_with_counter_plus(ref settings, min_room_size, max_room_size);

    let x = random_with_counter_plus(ref settings, 1, settings.size - 1 - width);
    let y = random_with_counter_plus(ref settings, 1, settings.size - 1 - height);

    Room { x: x, y: y, width: width, height: height }
}

fn is_valid_room(rooms: @Array<Room>, current: @Room) -> bool {
    let rooms_span = rooms.span();
    let mut length: u256 = rooms_span.len().into();

    if length > 0 {
        loop {
            if length == 0 {
                break true;
            }

            let room: Room = *rooms_span.at((length - 1).try_into().expect('invalid index'));
            if (room.x - 1 < *current.x + *current.width)
                && (room.x + room.width + 1 > *current.x)
                && (room.y - 1 < *current.x + *current.height)
                && (room.y + room.height > *current.y) {
                break false;
            }

            length -= 1;
        }
    } else {
        true
    }
}

fn mark_the_floor(ref floor: Felt252Dict<Nullable<u256>>, current: Room, size: u256) {
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

            floor.set_bit(y * size + x);

            x += 1;
        };
        y += 1;
    };
}

fn connect_halls_vertical(
    ref hallways: Felt252Dict<Nullable<u256>>,
    current_y: u256,
    previous_y: u256,
    x: u256,
    size: u256
) {
    let mut min: u256 = if current_y > previous_y {
        previous_y
    } else {
        current_y
    };
    let mut max: u256 = if current_y > previous_y {
        current_y
    } else {
        previous_y
    };
    let mut y = min;
    loop {
        if y == max {
            break;
        }
        hallways.set_bit(y * size + x);
        y += 1;
    };
}

fn connect_halls_horizontal(
    ref hallways: Felt252Dict<Nullable<u256>>,
    current_x: u256,
    previous_x: u256,
    y: u256,
    size: u256
) {
    let mut min: u256 = if current_x > previous_x {
        previous_x
    } else {
        current_x
    };
    let mut max: u256 = if current_x > previous_x {
        current_x
    } else {
        previous_x
    };
    let mut x = min;
    loop {
        if x == max {
            break;
        }
        hallways.set_bit(y * size + x);
        x += 1;
    }
}

fn get_direction(base_x: u256, base_y: u256, direction: u8) -> (u256, u256) {
    if direction == 0 {
        if base_x > 0 {
            (base_x - 1, base_y)
        } else {
            (base_x, base_y)
        }
    } else if direction == 1 {
        (base_x, base_y + 1)
    } else if direction == 2 {
        (base_x + 1, base_y)
    } else { // direction ==3
        if base_y > 0 {
            (base_x, base_y - 1)
        } else {
            (base_x, base_y)
        }
    }
}


fn is_left(direction: u8) -> bool {
    if direction == 0 {
        true
    } else {
        false
    }
}

fn clockwise_rotation(direction: u8) -> u8 {
    if direction == 3 {
        0
    } else {
        direction + 1
    }
}

fn counterclockwise_rotation(direction: u8) -> u8 {
    if direction == 0 {
        3
    } else {
        direction - 1
    }
}

fn generate_direction(ref settings: Settings) -> u8 {
    random_shift_counter_plus(ref settings, 1, 4).try_into().expect('over u8 range')
}

fn random_with_counter_plus(ref settings: Settings, min: u256, max: u256) -> u256 {
    let result = random(settings.seed + settings.counter, min, max);
    settings.counter += 1;
    result
}

fn random_shift_counter_plus(ref settings: Settings, min: u256, max: u256) -> u256 {
    let result = random(settings.seed.left_shift(settings.counter), min, max);
    settings.counter += 1;
    result
}

fn get_length(size: u256) -> u256 {
    size * size / 256 + 1
}

fn build_settings(seed: u256, size: u256) -> Settings {
    Settings { size: size, seed: seed, length: get_length(size), counter: 0 }
}

fn square_root(origin: u256) -> u256 {
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

// ------------------------------------------- Test -------------------------------------------

#[test]
#[available_gas(30000000)]
fn test_sqr() {
    assert(square_root(17) == 4, 'compute square root of 17');
    assert(square_root(24) == 4, 'compute square root of 24');
}

#[test]
// #[ignore]
#[available_gas(300000000000000)]
fn test_generate_room() {
    {}
    // tokenId 5678 cavern type
    let seed: u256 = 54726856408304506636278424762823059598933394071647911965527120692794348915138;
    let size: u256 = 20;

    let (mut map, mut structure) = get_layout(seed, size);
    // print_map(ref map, structure, size);
    assert(
        structure == 1
            && map.select(0) == 0x100001c030140201f020f902089c2088661b8641e0c07e0c0e47c1e66c1462
            && map.select(1) == 0xc1442c1c4781c6781c6384c6185c31cbc13c0000000000000000000000000000,
        'cavern error'
    );

    {}
    // tokenId 6666 room type
    let seed: u256 = 6335337818598560499429733180295617724328926230334923097623654911070136911834;
    let size: u256 = 17;

    let (mut map, mut structure) = get_layout(seed, size);
    print_map(ref map, structure, size);
    assert(
        structure == 0
            && map.select(0) == 0x18000c0000003fbc1ffe03ef01f000ffc00000
            && map.select(1) == 0x0,
        'room error'
    )
}

fn print_map(ref map: Felt252Dict<Nullable<u256>>, structure: u256, size: u256) {
    '--------layout display--------'.print();
    'structure'.print();
    let structure: u128 = structure.try_into().unwrap();
    structure.print();
    let length = size * size / 256;
    let mut count: u128 = 0;
    loop {
        if length + 1 == count.into() {
            break;
        }

        let value: u256 = map.select(count.into());
        'map index'.print();
        count.print();
        'map value'.print();
        value.print();

        count += 1;
    }
}
