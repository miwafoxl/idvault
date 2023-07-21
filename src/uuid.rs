use uuid::Uuid;

#[derive(Debug)]
pub struct UUID(String);

impl UUID {
    pub fn new() -> Self {
        UUID(Uuid::new_v4().as_hyphenated().to_string())
    }
}