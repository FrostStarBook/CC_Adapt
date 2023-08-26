use core::traits::TryInto;
use core::clone::Clone;

#[starknet::contract]
mod DungeonsGenerator {
    use starknet::ContractAddress;
    use openzeppelin::token::erc20::ERC20;

    use array::ArrayTrait;
    use debug::PrintTrait;

    use cc_map::utils::random;

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

    fn generate_rooms(settings: @Settings) -> (Array<Room>, Array<u128>) {
        let size = (*settings).size;
        let seed = (*settings).seed;
        let mut counter = (*settings).counter;

        let room_settings = RoomSettings {
            minRooms: size / 3, maxRooms: size / 1, minRoomSize: 2, maxRoomSize: size / 3
        };

        let mut floor: Array<u128> = ArrayTrait::new();

        let mut num_rooms: u128 = random::random(
            seed + counter, room_settings.minRooms, room_settings.maxRooms
        );
        counter = counter + 1;

        let mut rooms: Array<Room> = ArrayTrait::new();

        let mut safe_check = 256;

        loop {
            if num_rooms == 0 {
                break;
            }

            let mut valid = true;

            let seed1 = seed + counter;
            counter = counter + 1;
            let seed2 = seed + counter;

            let current: Room = Room {
                x: 0,
                y: 0,
                width: random::random(seed1, room_settings.minRoomSize, room_settings.maxRoomSize),
                height: random::random(seed2, room_settings.minRoomSize, room_settings.maxRoomSize)
            };

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
