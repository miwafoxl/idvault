use crate::uuid::UUID;
use crate::file::File;
use crate::coretypes as coretypes;

use coretypes::meta::Meta;
use coretypes::date::Date;

pub struct Creator {
    uuid: UUID,
    meta: Meta,
    alias: String,
    description: String,
    date_start: Date,
    date_end: Date,
}

impl File for Creator {}