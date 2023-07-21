use std::rc::Rc;

use crate::uuid::UUID;
use crate::file::File;
use crate::coretypes as coretypes;
use crate::components as components;

use super::feeling::Feeling;
use super::tag::Tag;

use coretypes::meta::Meta;

#[derive(Debug)]
pub struct Concept {
    uuid: UUID,
    meta: Meta,
    pub alias: String,
    pub description: String,
    pub feeling: Option<Vec<Feeling>>,
    pub tag: Option<Vec<Tag>>,
}

impl File for Concept {}


impl Concept {
    pub fn new(
        alias: String, 
        description: String, 
        feeling: Option<Vec<Feeling>>, 
        tag: Option<Vec<Tag>>) -> Self {
        Concept {
            uuid: UUID::new(),
            meta: Meta::new(),
            alias,
            description,
            feeling,
            tag,
        }
    }
    pub fn set_alias(&mut self, alias: &String) -> &Self {
        self.alias = alias.to_owned();
        self
    }
    pub fn set_description(&mut self, alias: &String) -> &Self {
        self.alias = alias.to_owned();
        self
    }
}