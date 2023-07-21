use crate::uuid::UUID;
use crate::file::File;
use crate::coretypes as coretypes;

use coretypes::meta::Meta;

#[derive(Debug)]
pub struct Feeling {
    uuid: UUID,
    meta: Meta,
    name: String,
    description: String,
}

impl File for Feeling {}