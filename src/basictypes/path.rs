use crate::uuid::UUID;
use crate::file::File;
use crate::coretypes as coretypes;

use coretypes::meta::Meta;
use coretypes::pathtype::PathType;

pub struct Path {
    uuid: UUID,
    meta: Meta,
    pathtype: PathType,
    path: String,
    version: u8,
}

impl File for Path {}