#[starknet::contract]
mod DungeonsGenerator {
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
    use cc_map::utils::random::{random_u256};
    use cc_map::utils::bit_operation::{left_shift, right_shift};

    #[storage]
    struct Storage {}

    #[derive(Copy, Drop)]
    struct EntityData {}

    #[derive(Copy, Drop, serded)]
    struct Settings {
        size: u256,
        length: u256,
        seed: u256,
        counter: u256
    }

    #[derive(Copy, Drop)]
    struct RoomSettings {
        minRooms: u256,
        maxRooms: u256,
        minRoomSize: u256,
        maxRoomSize: u256
    }

    #[derive(Copy, Drop)]
    struct Room {
        x: u256,
        y: u256,
        width: u256,
        height: u256
    }

    #[constructor]
    fn constructor(ref self: ContractState) {}

    fn get_length(size: u256) -> u256 {
        ((size * size) / 256) + 1
    }

    fn set_mark(ref self: Felt252Dict<Nullable<Span<u8>>>, x: u256, y: u256) {
        self.get(x.try_into().unwrap());

        let array_origin: Span<u8> = match match_nullable(self.get(x.try_into().unwrap())) {
            FromNullableResult::Null(()) => panic_with_felt252('No array inside'),
            FromNullableResult::NotNull(val) => val.unbox(),
        };

        if *array_origin.at(y.try_into().unwrap()) != 1 {
            let mut array_new: Array<u8> = ArrayTrait::new();
            let len: u32 = array_origin.len();
            let mut count: u32 = 0;
            loop {
                if count == len {
                    break;
                }

                if count.into() == y {
                    array_new.append(1);
                } else {
                    array_new.append(*array_origin.at(count));
                }

                count += 1;
            };

            self.insert(x.try_into().unwrap(), nullable_from_box(BoxTrait::new(array_new.span())));
        }
    }

    fn generate_rooms(
        settings: @Settings
    ) -> (Felt252Dict<Nullable<Room>>, Felt252Dict<Nullable<Span<u8>>>) {
        let size = (*settings).size;
        let seed = (*settings).seed;
        let mut counter = (*settings).counter;

        let room_settings = RoomSettings {
            minRooms: size / 3, maxRooms: size / 1, minRoomSize: 2, maxRoomSize: size / 3
        };

        'floor init'.print();
        // initialize the floor
        let mut floor: Felt252Dict<Nullable<Span<u8>>> = Default::default();
        let mut size_count = size;
        'size'.print();
        size.print();
        loop {
            if size_count == 0 {
                break;
            }

            let mut array_inside: Array<u8> = ArrayTrait::new();
            let mut size_inside = size;
            loop {
                if size_inside == 0 {
                    break;
                }
                array_inside.append(0);

                'array_append'.print();
                size_inside -= 1;
            };

            floor
                .insert(
                    (counter - 1).try_into().unwrap(),
                    nullable_from_box(BoxTrait::new(array_inside.span()))
                );

            'size_count'.print();
            size_count.print();
            size_count -= 1;
        };

        'num_rooms'.print();
        let mut num_rooms: u256 = random_u256(
            seed + counter, room_settings.minRooms, room_settings.maxRooms
        );
        counter = counter + 1;

        let mut rooms: Felt252Dict<Nullable<Room>> = Default::default();

        let mut safe_check = 256;

        let mut has_room = false;
        let num_rooms_copy = num_rooms;

        'first loop'.print();
        loop {
            if num_rooms == 0 {
                break;
            }

            let mut valid = true;

            let seed1 = seed + counter;
            counter = counter + 1;
            let seed2 = seed + counter;
            counter = counter + 1;
            let seed3 = seed + counter;
            counter = counter + 1;
            let seed4 = seed + counter;
            counter = counter + 1;

            'Room{}'.print();
            let mut current: Room = Room {
                x: 0,
                y: 0,
                width: random_u256(seed1, room_settings.minRoomSize, room_settings.maxRoomSize),
                height: random_u256(seed2, room_settings.minRoomSize, room_settings.maxRoomSize)
            };

            'current'.print();
            current.x = random_u256(seed3, 1, *settings.size - 1 - current.width);
            current.y = random_u256(seed4, 1, *settings.size - 1 - current.height);

            if has_room {
                let mut count: u256 = 0;
                let num_rooms_copy = num_rooms;
                'second loop'.print();
                loop {
                    if count == num_rooms_copy - num_rooms {
                        break;
                    }

                    let room_nullable: Nullable<Room> = rooms.get(count.try_into().unwrap());
                    let room = match match_nullable(room_nullable) {
                        FromNullableResult::Null => panic_with_felt252('No Room!'),
                        FromNullableResult::NotNull(room_nullable) => room_nullable.unbox()
                    };

                    if (room.x - 1 < current.x + current.width)
                        && (room.x + room.width + 1 > current.x)
                        && (room.y - 1 < current.x + current.height)
                        && (room.y + room.height > current.y) {
                        valid = false;
                    }

                    count += 1;
                };
            } else {
                match match_nullable(rooms.get(0.into())) {
                    FromNullableResult::Null => (),
                    FromNullableResult::NotNull(v) => {
                        has_room = true;
                    }
                };
            }

            if valid {
                rooms
                    .insert(
                        (num_rooms_copy - num_rooms).try_into().unwrap(),
                        nullable_from_box(BoxTrait::new(current))
                    );

                let mut y = current.y;
                'third loop'.print();
                loop {
                    if y == current.y + current.height {
                        break;
                    }

                    let mut x = current.x;
                    'fourth loop'.print();
                    loop {
                        if x == current.x + current.width {
                            break;
                        }

                        set_mark(ref floor, x, y);

                        x += 1;
                    };

                    y += 1;
                };
            }

            if safe_check == 0 {
                break;
            }

            safe_check = safe_check - 1;
        };
        'loop end'.print();

        (rooms, floor)
    }
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
    use super::DungeonsGenerator;

    #[test]
    #[available_gas(30000000000000000000000000000000)]
    fn test_generate_room() {
        let settings = DungeonsGenerator::Settings { size: 3, length: 3, seed: 3, counter: 3 };
        let (mut rooms, mut floor) = DungeonsGenerator::generate_rooms(@settings);

        let mut count = 0;
        loop {
            if count == 10 {
                break;
            }

            let room = match match_nullable(rooms.get(count)) {
                FromNullableResult::Null => panic_with_felt252('No room'),
                FromNullableResult::NotNull(val) => val.unbox()
            };

            room.x.print();
            room.y.print();
            room.width.print();
            room.height.print();

            count += 1;
        }
    }
}
