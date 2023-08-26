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

    #[derive(Copy, Drop, starknet::storage)]
    struct Settings {
        size: u256,
        length: u256,
        seed: u256,
        counter: u256
    }

    #[derive(Copy, Drop, starknet::storage)]
    struct RoomSettings {
        minRooms: u256,
        maxRooms: u256,
        minRoomSize: u256,
        maxRoomSize: u256
    }

    #[derive(Copy, Drop, starknet::storage)]
    struct Room {
        x: u256,
        y: u256,
        width: u256,
        height: u256
    }

    // #[derive(Copy, Drop, Serde, starknet::storage)]
    // enum Direction {
    //     Left,
    //     Up,
    //     Right,
    //     Down
    // }

    #[constructor]
    fn constructor() {}

    fn generate_rooms(settings: @Settings) -> (Array<Room>, Array<u256>) {
        let room_settings = RoomSettings {
            minRooms: settings.size / 3,
            maxRooms: settings.size / 1,
            minRoomSize: 2,
            maxRoomSize: settings.size / 3
        };

        let floor: Array<u256> = Array::new(settings.length);

        let mut num_rooms: u256 = random::random(room_settings.minRooms, room_settings.maxRooms);

        let rooms: Array<Room> = Array::new(num_rooms);

        let mut safe_check = 256;

        while
        num_rooms > 0
        {
            let mut valid = true;
            // let current :Room = 
        }
    }
}

#[cfg(test)]
mod tests {}
