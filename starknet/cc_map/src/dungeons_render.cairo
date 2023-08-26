use core::array::ArrayTrait;
#[starknet::contract]
mod DungeonsRender {
    use array::ArrayTrait;
    use option::OptionTrait;
    use traits::{Into, TryInto};

    use cc_map::interface::IDungeonsRender;
    use cc_map::dungeons::Dungeons::Dungeon;

    /// Data structure that stores our different maps (layout, doors, points)
    #[derive(Drop)]
    struct Maps {
        layout: Array<felt252>,
        doors: Array<felt252>,
        points: Array<felt252>,
    }

    /// Helper variables when iterating through and drawing dungeon tiles
    #[derive(Drop)]
    struct RenderHelper {
        pixel: u256,
        start: u256,
        layout: Array<felt252>,
        parts: felt252,
        counter: u256,
        numRects: u256,
        lastStart: u256,
    }

    #[derive(Copy, Drop)]
    struct EntityHelper {
        size: u256,
        environment: u256,
    }

    #[storage]
    struct Storage {
        // Array contains sets of 4 colors:
        // 0 = bg, 1 = wall, 2 = door, 3 = point
        // To calculate, multiply environment (int 0-5) by 4 and add the above numbers.        
        colors: LegacyMap::<u8, felt252>,
        // Names mapped to the above colors
        environmentName: LegacyMap::<u8, felt252>,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        // Init colors
        // Desert
        self.colors.write(0, 'F3D899');
        self.colors.write(1, '160F09');
        self.colors.write(2, 'FAAA00');
        self.colors.write(3, '00A29D');
        // Stone Temple
        self.colors.write(4, '967E67');
        self.colors.write(5, 'F3D899');
        self.colors.write(6, '3C2A1A');
        self.colors.write(7, '006669');
        // Forest Ruins
        self.colors.write(8, '2F590E');
        self.colors.write(9, 'A98C00');
        self.colors.write(10, '802F1A');
        self.colors.write(11, 'C55300');
        // Mountain Deep
        self.colors.write(12, '36230F');
        self.colors.write(13, '744936');
        self.colors.write(14, '802F1A');
        self.colors.write(15, 'FFA800');
        // Underwater Keep
        self.colors.write(16, '006669');
        self.colors.write(17, '004238');
        self.colors.write(18, '967E67');
        self.colors.write(19, 'F9B569');
        // Ember"s Glow
        self.colors.write(20, '340D07');
        self.colors.write(21, '5D0503');
        self.colors.write(22, 'B75700');
        self.colors.write(23, 'FF1800');
        // Init environmentName
        self.environmentName.write(0, 'Desert Oasis');
        self.environmentName.write(1, 'Stone Temple');
        self.environmentName.write(2, 'Forest Ruins');
        self.environmentName.write(3, 'Mountain Deep');
        self.environmentName.write(4, 'Underwater Keep');
        self.environmentName.write(5, 'Embers Glow');
    }

    // #[external(v0)]
    // impl DungeonsRenderImpl of IDungeonsRender<ContractState> {
    //     fn draw(
    //         ref self: ContractState, dungeon: Dungeon, x: Array<u8>, y: Array<u8>, entityData: Array<u8>
    //     ) -> felt252 {
    //         // Hardcoded to save memory: Width = 100
    //         // Setup SVG and draw our background
    //         // We write at 100x100 and scale it 5x to 500x500 to avoid safari small rendering
    //         let mut parts: felt252 = 

    //     }
    //     fn tokenURI(
    //         ref self: ContractState, tokenId: u256, dungeon: Dungeon, entities: Array<u256>
    //     ) -> felt252 {

    //     }
    // }

    //
    // Internal
    //

    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {

        fn drawTile(row: felt252, x: u256, y: u256, width: u256, pixel: u256, color: felt252) -> Array<felt252> {
            let mut title: Array<felt252> = ArrayTrait::new();
            title.append(row);
            title.append('<rect x="');
            title.append(x.try_into().unwrap());
            title.append('" y="');
            title.append(y.try_into().unwrap());
            title.append('" width="');
            title.append(width.try_into().unwrap());
            title.append('" height="');
            title.append(pixel.try_into().unwrap());
            title.append('" fill="#');
            title.append(color);
            title.append('" />');
            
            title
        }

        fn getWidth(size: u256) -> (u256, u256) {
            // Each 'pixel' should be equal widths and take into account dungeon size + allocate padding (3 pixels) on both sides
            let pixel: u256 = 500 / (size + 3 * 2);
            // Remove the width and divide by two to get the midpoint where we should start
            let start: u256 = (500 - pixel * size) / 2;
            (start, pixel)
        }
    }
}

// ---------------------------
// ---------- Tests ----------
// ---------------------------
#[cfg(test)]
mod tests {
    use cc_map::{dungeons_render::DungeonsRender::{InternalFunctions}};
    use array::ArrayTrait;

    #[test]
    fn test_draw_tile() {
        let tile: Array<felt252> = InternalFunctions::drawTile('row', 1, 2, 3, 4, 'F3D899');
        assert(tile.len() == 12_usize, 'the right length');
        assert(*tile.at(0_usize) == 'row', 'the right row');
        assert(*tile.at(1_usize) == '<rect x="', 'the right rect');
        assert(*tile.at(2_usize) == 1, 'the right x');
        assert(*tile.at(10_usize) == 'F3D899', 'the right color');
    }

    #[test]
    fn test_get_witdth() {
        let (start, pixel) = InternalFunctions::getWidth(4);
        assert(pixel == 50, 'pixel is right');
        assert(start == 150, 'start is right');
    }
}
