use crate::uuid::UUID;
use crate::file::File;
use crate::coretypes as coretypes;

use super::genre::Genre;

use coretypes::meta::Meta;
use coretypes::date::Date;

pub struct Distribution {
    uuid: UUID,
    meta: Meta,
    name: String,
    description: String,
    genre: Vec<Genre>,
    date_start: Date,
    date_end: Date,
}

impl File for Distribution {}