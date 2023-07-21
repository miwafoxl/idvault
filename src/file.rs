use serde_json;
use std::fs;
use std::path::Path;
use std::io::Write;
use std::io::Result as IoResult;
use serde::{Serialize};

pub trait File {
    fn stringify(&self) -> String where Self: Serialize {
        serde_json::to_string(self).unwrap()
    }

    fn writejson(&self, path: &Path) -> IoResult<()> where Self: Serialize {
        let json_str: String = self.stringify();
        let mut file = fs::File::create(path)?;
        file.write_all(json_str.as_bytes())?;
        Ok(())
    }

    fn deletejson(&self, path: &Path) -> IoResult<()> {
        fs::remove_file(path)?;
        Ok(())
    }

    fn readjson(&self) {todo!()}
}