use godot::prelude::*;
use mines::{position::Position, MineMap};

#[derive(GodotClass)]
#[class(base=Node)]
pub struct Main {
    mines: MineMap,

    #[base]
    base: Base<Node>,
}

#[godot_api]
impl Main {
    #[func]
    fn update_mark(&mut self, x: u8, y: u8, mark_val: u8) {
        self.mines.update_by(x, y, mark_val)
    }

    #[func]
    fn get_around(&mut self, x: u8, y: u8) -> Array<Vector2i> {
        Position(x, y)
            .get_around(Position(self.mines.width, self.mines.height))
            .into_iter()
            .map(|Position(a, b)| Vector2i {
                x: a as i32,
                y: b as i32,
            })
            .collect()
    }

    #[func]
    fn get_nearby_empty_area(&mut self, x: u8, y: u8) -> Array<Vector2i> {
        self.mines
            .get_nearby_empty_area(x, y)
            .into_iter()
            .map(|Position(a, b)| Vector2i {
                x: a as i32,
                y: b as i32,
            })
            .collect()
    }

    #[func]
    fn get_mark_val(&self, x: u8, y: u8) -> u8 {
        self.mines.get(x, y).0
    }

    #[func]
    fn print_format(&self) {
        godot_print!("{}", self.mines.format_str())
    }

    #[func]
    fn reset_mine_map(&mut self, count: u16, width: u8, height: u8) {
        self.mines = MineMap::from(count, width, height);
    }

    #[func]
    fn shuffle(&mut self) {
        self.mines.shuffle(None)
    }

    #[func]
    fn shuffle_ignore(&mut self, x: u8, y: u8) {
        self.mines
            .shuffle(if x > self.mines.width || y > self.mines.height {
                None
            } else {
                Some(Position(x, y))
            });
        self.mines.open(x, y)
    }

    #[func]
    fn open(&mut self, x: u8, y: u8) {
        self.mines.open(x, y)
    }

    #[func]
    fn switch_flag(&mut self, x: u8, y: u8) {
        self.mines.set_flag(x, y)
    }

    #[func]
    fn is_empty(&self, x: u8, y: u8) -> bool {
        self.mines.get(x, y).is_empty()
    }

    #[func]
    fn is_flagged(&self, x: u8, y: u8) -> bool {
        self.mines.get(x, y).is_flagged()
    }

    #[func]
    fn is_mine(&self, x: u8, y: u8) -> bool {
        self.mines.get(x, y).is_mine()
    }
}

#[godot_api]
impl NodeVirtual for Main {
    fn init(base: Base<Node>) -> Self {
        Self {
            mines: MineMap::from(0, 0, 0),
            base,
        }
    }
}
