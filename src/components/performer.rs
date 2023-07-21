use crate::coretypes as coretypes;
use crate::basictypes as basictypes;

use super::creator::Creator;

use basictypes::entity::Entity;
use coretypes::meta::Meta;
use coretypes::performancetype::PerformanceType;

enum PerformerType {
    Creator(Creator),
    Entity(Entity),
}

// fui fazer leitin com café afk
// EU DERRUBEI O LEITE NA MESA AAAAAAAAAAAAAAAAAAA

pub struct Performer {
    meta: Meta,
    role: PerformanceType,
    performer: PerformerType,
}

