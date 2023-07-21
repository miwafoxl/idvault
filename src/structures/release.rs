use crate::uuid::UUID;
use crate::file::File;
use crate::coretypes as coretypes;
use crate::basictypes as basictypes;
use crate::components as components;

use super::collection::Collection;

use coretypes::meta::Meta;
use coretypes::date::Date;
use basictypes::path::Path;
use components::idea::Idea;

enum ReleaseType {
    Collection(Collection),
    Idea(Idea),
}

pub struct Release {
    uuid: UUID,
    meta: Meta,
    cover: Path,
    releaseof: ReleaseType,
    description: String,
    date_release: Date,
}