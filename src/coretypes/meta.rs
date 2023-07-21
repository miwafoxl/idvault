use std::io::Empty;

use chrono::Utc;
use chrono::prelude::*;

#[derive(Debug)]
pub struct Meta {
    local_created: i64,
    date_created: String,
    date_modified: String,
}

impl Meta {
    pub fn new() -> Meta {
        let now: String = Utc::now().to_rfc2822();
        let ts: i64 = Utc::now().timestamp();
        Meta {
            local_created: ts,
            date_created: now.to_owned(),
            date_modified: now.to_owned(),
        }
    }
    pub fn update(&mut self) -> &Self {
        let now: String = Utc::now().to_rfc2822();
        self.date_modified = now;
        self
    }
}