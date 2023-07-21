use crate::uuid::UUID;
use crate::file::File;
use crate::coretypes as coretypes;

use coretypes::meta::Meta;

#[derive(Debug)]
pub struct Tag {
    uuid: UUID,
    meta: Meta,
    alias: String,
    description: String,
    children: Option<Vec<Box<Tag>>>,
}

impl File for Tag {}