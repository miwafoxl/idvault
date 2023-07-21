#![allow(dead_code)]
#![allow(unused_imports)]

mod uuid;
mod file;
mod queue;

mod coretypes;
use coretypes::meta::Meta;
mod basictypes;
mod components;
use components::concept::Concept;
use components::feeling::Feeling;
mod structures;

fn main() {
    let mut test = Concept::new(
        String::new(),
        String::new(),
        None,
        None,
    );
    println!("{:?}", &test);
}