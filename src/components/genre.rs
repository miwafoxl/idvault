use crate::uuid::UUID;
use crate::file::File;
use crate::coretypes as coretypes;

use coretypes::meta::Meta;

pub struct Genre {
    uuid: UUID,
    meta: Meta,
    name: String,
    description: String,
    tag: usize,
}

impl File for Genre {}