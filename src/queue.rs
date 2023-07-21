use crate::components::concept::Concept;


enum NodeType {
    Concept(&Concept)
}

enum EditType {
    Modify,
    Erase,
    Save,
    Delete,
}

pub struct Edit {
    nodetype: NodeType,
    edittype: EditType,
    
}