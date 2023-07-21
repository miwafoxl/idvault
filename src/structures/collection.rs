use crate::uuid::UUID;
use crate::file::File;
use crate::coretypes as coretypes;
use crate::components as components;

use coretypes::collectiontype::CollectionType;
use coretypes::date::Date;
use coretypes::meta::Meta;
use coretypes::status::Status;
use components::creator::Creator;
use components::idea::Idea;
use components::distribution::Distribution;

enum HostType {
    Distribution(Distribution),
    Creator(Creator),
}

pub struct Collection {
    uuid: UUID,
    meta: Meta,
    uid: String,
    description: String,
    title: String,
    subtitle: String,
    codename: String,
    host: HostType,
    status: Status,
    sucessor: Box<Collection>,
    predecessor: Box<Collection>,
    generation: Vec<Box<Collection>>, // holy moly
    tracklist: Vec<Idea>,
    date_start: Date,
    date_end: Date,
    rating: u8,
}

impl File for Collection {}