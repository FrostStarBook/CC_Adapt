#[starknet::contract]
mod DungeonsGenerator {
    use core::traits::{Into, TryInto};
    use core::option::OptionTrait;
    use core::array::SpanTrait;
    use core::dict::Felt252DictTrait;

    use starknet::ContractAddress;
    use openzeppelin::token::erc20::ERC20;
    use array::ArrayTrait;
    use cc_map::utils::random::{random};
    use cc_map::utils::bit_operation::{left_shift, right_shift};

    #[storage]
    struct Storage {}

    #[derive(Copy, Drop)]
    struct EntityData {}

    #[derive(Copy, Drop, serde, starknet::storage)]
    struct Settings {
        size: u128,
        length: u128,
        seed: u128,
        counter: u128
    }

    #[derive(Copy, Drop, starknet::storage)]
    struct RoomSettings {
        minRooms: u128,
        maxRooms: u128,
        minRoomSize: u128,
        maxRoomSize: u128
    }

    #[derive(Copy, Drop, starknet::storage)]
    struct Room {
        x: u128,
        y: u128,
        width: u128,
        height: u128
    }

    // #[derive(Copy, Drop, Serde, starknet::storage)]
    // enum Direction {
    //     Left,
    //     Up,
    //     Right,
    //     Down
    // }

    #[constructor]
    fn constructor(ref self: ContractState) {}

    fn get_length(size: u128) -> u128 {
        ((size * size) / 256) + 1
    }

    #[external(v0)]
    fn get_layout(self: ContractState, seed: u128, size: u128) -> (Array<felt252>, u128) {
        let settings: Settings = Settings {
            size: size, length: get_length(size), seed: seed, counter: 0
        };
        let structure = 0;

        if (random(left_shift(settings.seed, settings.counter), 0, 100)) > 30 {
            // Generate Rooms
            let (rooms, floor) = generate_rooms(@settings);
        // Generate Hallways
        // let hallways = generate_hallways(@settings,@rooms);

        // Combine floor and hallway tiles

        // Caverns-based dungeon

        }
        (ArrayTrait::new(), 0)
    }

    fn generate_rooms(settings: @Settings) -> (Felt252Dict<Room>, Felt252Dict<Felt252Dict<u8>>) {
        let size = (*settings).size;
        let seed = (*settings).seed;
        let mut counter = (*settings).counter;

        let room_settings = RoomSettings {
            minRooms: size / 3, maxRooms: size / 1, minRoomSize: 2, maxRoomSize: size / 3
        };

        let mut floor: Felt252Dict<Felt252Dict<u8>> = Default::default();

        let mut num_rooms: u128 = random(
            seed + counter, room_settings.minRooms, room_settings.maxRooms
        )
            .try_into()
            .unwrap();
        counter = counter + 1;

        let mut rooms: Felt252Dict<Room> = Default::default();

        let mut safe_check = 256;

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

            let mut current: Room = Room {
                x: 0,
                y: 0,
                width: random(seed1, room_settings.minRoomSize, room_settings.maxRoomSize)
                    .try_into()
                    .unwrap(),
                height: random(seed2, room_settings.minRoomSize, room_settings.maxRoomSize)
                    .try_into()
                    .unwrap()
            };

            current.x = random(seed3, 1, *settings.size - 1 - current.width).try_into().unwrap();
            current.y = random(seed4, 1, *settings.size - 1 - current.height).try_into().unwrap();

            // TODO 
            // let rooms_span = rooms.span();
            // if (!rooms_span.is_empty()) {
            //     let mut i: u32 = 0;
            //     loop {
            //         if i > rooms_span.len() - num_rooms.try_into().unwrap() {
            //             break;
            //         }

            //         let room: Room = *rooms_span[i];
            //         if room.x
            //             - 1 < current.x
            //             + current.width && room.x
            //             + room.width
            //             + 1 > current.x && room.y
            //             - 1 < current.x
            //             + current.height && room.y
            //             + room.height > current.y {
            //             valid = false;
            //         }

            //         i = i + 1;
            //     }
            // }

            if valid {
                num_rooms = num_rooms - 1;
            }

            if safe_check == 0 {
                break;
            }

            safe_check = safe_check - 1;
        };

        (rooms, floor)
    }
}

#[cfg(test)]
mod tests {}
