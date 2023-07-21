use crate::coretypes::meta::Meta;
use crate::coretypes::date::Date;
use crate::coretypes::gender::Gender;

pub struct Entity {
    meta: Meta,
    name: String,
    gender: Gender,
    date_birth: Date,
    date_death: Date,
}