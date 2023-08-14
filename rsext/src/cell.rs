use godot::{
    engine::{Button, ButtonVirtual},
    prelude::*,
};
use mines::mark::Mark;

#[derive(GodotClass)]
#[class(base=Button)]
pub struct MineCell {
    pub mark: Mark,

    #[var(get, set)]
    pub x: u8,
    #[var(get, set)]
    pub y: u8,
    #[base]
    base: Base<Button>,
}

#[godot_api]
impl MineCell {
    // #[signal]
    // fn cell_update(x: u8, y: u8, mark_val: u8);
    // #[signal]
    // fn open_around(x: u8, y: u8);
    // #[signal]
    // fn ext_call_update();

    #[func]
    pub fn get_mark_val(&self) -> u8 {
        self.mark.0
    }
    #[func]
    pub fn get_warn(&self) -> u8 {
        self.mark.get_warn()
    }
    #[func]
    pub fn is_open(&self) -> bool {
        self.mark.is_open()
    }
    #[func]
    pub fn is_mine(&self) -> bool {
        self.mark.is_mine()
    }
    #[func]
    pub fn is_flagged(&self) -> bool {
        self.mark.is_flagged()
    }
    #[func]
    pub fn guess_safe(&self) -> bool {
        self.mark.guess_safe()
    }
    #[func]
    pub fn guess_suspicious(&self) -> bool {
        self.mark.guess_suspicious()
    }
    #[func]
    pub fn guess_mine(&self) -> bool {
        self.mark.guess_mine()
    }
    #[func]
    pub fn open(&mut self) {
        self.mark.open();
        // let _ = self.emit_update();
    }
    #[func]
    pub fn switch_flag(&mut self) {
        self.mark.set_flag();
        // let _ = self.emit_update();
    }
    #[func]
    pub fn set_guess_safe(&mut self) {
        self.mark.set_safe()
    }
    #[func]
    pub fn set_guess_suspicious(&mut self) {
        self.mark.set_suspicious()
    }
    #[func]
    pub fn set_mark_val(&mut self, val: u8) {
        self.mark = Mark(val);
        // let _ = self.emit_update();
    }
}

#[godot_api]
impl ButtonVirtual for MineCell {
    fn init(base: Base<Button>) -> Self {
        Self {
            mark: Mark(0),
            y: 0,
            x: 0,
            base,
        }
    }
}
