#[starknet::contract]
mod DungeonsRender {
    use array::ArrayTrait;

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
    
    /// Names mapped to the above colors

    #[storage]
    struct Storage {

    }

    //
    // Internal
    //

    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn getWidth(size: u256) -> (u256, u256) {
            // Each 'pixel' should be equal widths and take into account dungeon size + allocate padding (3 pixels) on both sides
            let pixel: u256 = 500 / (size + 3*2);
            // Remove the width and divide by two to get the midpoint where we should start
            let start: u256 = (500 - pixel*size) / 2;
            (start, pixel)
        }
    }
    
}

// ---------------------------
// ---------- Tests ----------
// ---------------------------
#[cfg(test)]
mod tests {
    use cc_map::{
        dungeons_render::DungeonsRender::{ InternalFunctions }
    };

    #[test]
    fn test_get_witdth() {
        let (start, pixel) = InternalFunctions::getWidth(4);
        assert(pixel == 50, 'pixel is right');
        assert(start == 150, 'start is right');
    }
}