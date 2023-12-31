#[starknet::contract]
mod DungeonsRender {
    use core::clone::Clone;
    use core::array::SpanTrait;
    use array::ArrayTrait;
    use option::OptionTrait;
    use traits::{Into, TryInto};
    use cc_map::interface::IDungeonsRender;
    use cc_map::dungeons::Dungeons::{Dungeon, EntityData};

    /// Data structure that stores our different maps (layout, doors, points)
    #[derive(Drop)]
    struct Maps {
        layout: Span<(u8, u8)>,
        doors: Span<(u8, u8)>,
        points: Span<(u8, u8)>,
    }

    /// Helper variables when iterating through and drawing dungeon tiles
    #[derive(Drop)]
    struct RenderHelper {
        pixel: u256,
        start: u256,
        layout: Span<(u8, u8)>,
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

    #[external(v0)]
    impl DungeonsRenderImpl of IDungeonsRender<ContractState> {
        fn draw(
            ref self: ContractState,
            dungeon: Dungeon,
            x: Span<u8>,
            y: Span<u8>,
            entity_data: Span<u8>
        ) -> Array<felt252> {
            // Hardcoded to save memory: Width = 100
            // Setup SVG and draw our background
            // We write at 100x100 and scale it 5x to 500x500 to avoid safari small rendering
            let mut parts: Array<felt252> = ArrayTrait::new();
            parts.append('<svg xmlns=');
            parts.append('"http://www.w3.org/2000/svg"');
            parts.append(' preserveAspectRatio=');
            parts.append('"xMinYMin meet"');
            parts.append(' viewBox="0 0 500 500"');
            parts.append(' shape-rendering="crispEdges"');
            parts.append(' transform-origin="center">');
            parts.append('<rect width="100%"');
            parts.append('height="100%" fill="#');
            parts.append(self.colors.read(dungeon.environment * 4));
            parts.append('" />');

            parts.append('</svg>');

            parts
        }

        fn tokenURI(
            ref self: ContractState, tokenId: u256, dungeon: Dungeon, entities: EntityData
        ) -> Array<felt252> {
            let mut output: Array<felt252> = ArrayTrait::new();

            // Generate dungeon
            output = self
                .draw(
                    dungeon, dungeon.entities.x, dungeon.entities.y, dungeon.entities.entity_data
                );

            // Base64 Encode svg and output
            let mut json: Array<felt252> = ArrayTrait::new();
            json.append('{"name": "Crypts and Caverns #');
            json.append(tokenId.try_into().unwrap());
            json.append('", "description": "Crypts and ');
            json.append('Caverns is an onchain map ');
            json.append('generator that produces an ');
            json.append('infinite set of dungeons. ');
            json.append('Enemies, treasure, etc ');
            json.append('intentionally omitted for');
            json.append(' others to interpret. ');
            json.append('Feel free to use Crypts and ');
            json.append('Caverns in any way you want."');
            json.append(', "attributes": [ {');
            json.append('"trait_type": "name", ');
            json.append('"value": "');
            // json.append(dungeon.dungeon_name);
            json.append('"}, {"trait_type": ');
            json.append('"size", "value": "');
            json.append(dungeon.size.into());
            json.append('x');
            json.append(dungeon.size.into());
            json.append('"}, {"trait_type": ');
            json.append('"environment", "value": "');
            json.append(self.environmentName.read(dungeon.environment));
            json.append('"}, {"trait_type": ');
            json.append('"doors", "value": "');
            // json.append(entities[1]);
            json.append('"}, {"trait_type": ');
            json.append('"points of interest",');
            json.append(' "value": "');
            // json.append(entities[0]);
            json.append('"}, {"trait_type":');
            json.append(' "affinity", "value": "');
            json.append(dungeon.affinity);
            json.append('"}, {"trait_type":');
            json.append(' "legendary", "value": "');
            if (dungeon.legendary == 1) {
                json.append('Yes');
            } else {
                json.append('No');
            }
            if (dungeon.structure == 0) {
                json.append('Crypt');
            } else {
                json.append('Cavern');
            }
            json.append('"}],"image":');
            json.append(' "data:image/svg+xml;base64,');
            // TODO base64 encode svg

            json.append('"}');
            // TODO base64 encode json

            output.append('data:application/json;base64,');
            // output.append(json);

            output
        }
    }

    //
    // Internal
    //
    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        // Draw each entity as a pixel on the map
        fn drawEntities(
            self: @ContractState,
            x: Array<u8>,
            y: Array<u8>,
            entityData: Array<u8>,
            dungeon: Dungeon,
            helper: RenderHelper
        ) -> Array<felt252> {
            let mut parts: Array<felt252> = ArrayTrait::new();

            let mut i: usize = 1;
            loop {
                if i > entityData.len() {
                    break;
                }
                let xU256: u256 = helper.start + (*x.at(i) % dungeon.size).into() * helper.pixel;
                let yU256: u256 = helper.start + (*y.at(i)).into() * helper.pixel;
                let colorIndex: u8 = dungeon.environment * 4 + 2 + *entityData.at(i);
                let color: felt252 = self.colors.read(colorIndex);
                // parts = self.drawTile(parts, xU256, yU256, helper.pixel, helper.pixel, color);

                i += 1;
            };
            parts
        }

        fn drawTile(
            row: Array<felt252>, x: u256, y: u256, width: u256, pixel: u256, color: felt252
        ) -> Array<felt252> {
            let mut tile: Array<felt252> = row;
            tile.append('<rect x="');
            tile.append(x.try_into().unwrap());
            tile.append('" y="');
            tile.append(y.try_into().unwrap());
            tile.append('" width="');
            tile.append(width.try_into().unwrap());
            tile.append('" height="');
            tile.append(pixel.try_into().unwrap());
            tile.append('" fill="#');
            tile.append(color);
            tile.append('" />');

            tile
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
    #[ignore]
    #[available_gas(30000000)]
    fn test_draw_tile() {
        let mut row: Array<felt252> = ArrayTrait::new();
        row.append('row');
        let tile: Array<felt252> = InternalFunctions::drawTile(row, 1, 2, 3, 4, 'F3D899');
        assert(tile.len() == 12_usize, 'the right length');
        assert(*tile.at(1_usize) == '<rect x="', 'the right rect');
        assert(*tile.at(2_usize) == 1, 'the right x');
        assert(*tile.at(10_usize) == 'F3D899', 'the right color');
    }

    #[test]
    #[ignore]
    #[available_gas(30000000)]
    fn test_get_witdth() {
        let (start, pixel) = InternalFunctions::getWidth(4);
        assert(pixel == 50, 'pixel is right');
        assert(start == 150, 'start is right');
    }
}
