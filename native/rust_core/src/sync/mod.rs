use yrs::{Doc, ReadTxn, Transact};
use yrs::updates::encoder::Encode;

pub struct SyncEngine {
    doc: Doc,
}

impl Default for SyncEngine {
    fn default() -> Self {
        Self { doc: Doc::new() }
    }
}

impl SyncEngine {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn encode_state_vector(&self) -> Vec<u8> {
        let txn = self.doc.transact();
        txn.state_vector().encode_v1()
    }
}

