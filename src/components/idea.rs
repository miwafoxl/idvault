use crate::uuid::UUID;
use crate::file::File;
use crate::coretypes as coretypes;
use crate::basictypes as basictypes;

use super::genre::Genre;
use super::feeling::Feeling;
use super::performer::Performer;

use coretypes::date::Date;
use coretypes::ideatype::IdeaType;
use coretypes::meta::Meta;
use coretypes::status::Status;
use basictypes::path::Path;

pub struct Idea {
    uuid: UUID, // UUID -> Unique Universal ID
    meta: Meta,
    uid: String, // UID -> User ID
    description: String,
    title: String,
    subtitle: String,
    codename: String,
    performance: Vec<Performer>,
    status: Status,
    ideatype: IdeaType,
    feeling: Vec<Feeling>,
    genre: Vec<Genre>,
    sucessor: Box<Idea>,
    predecessor: Box<Idea>,
    generation: Vec<Box<Idea>>, // what the fuck?
    path_project: Vec<Path>,
    path_audio: Vec<Path>,
    path_master: Path,
    date_start: Date,
    date_finish: Date,
    rating: u8,
    // tag: Vec<Tag>
}

impl File for Idea {}