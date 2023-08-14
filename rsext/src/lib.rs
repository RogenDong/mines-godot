use godot::prelude::*;

pub mod cell;
pub mod main_scen;

struct TsGdRs;
#[gdextension]
unsafe impl ExtensionLibrary for TsGdRs {}
