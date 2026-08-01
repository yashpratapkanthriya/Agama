use yrs::{Doc, ReadTxn, Transact, Update};
use yrs::updates::encoder::Encode;
use yrs::updates::decoder::Decode;

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

    pub fn generate_delta_blob(&self) -> Vec<u8> {
        let txn = self.doc.transact();
        txn.encode_state_as_update_v1(&yrs::StateVector::default())
    }

    pub fn apply_remote_delta(&mut self, update_bytes: &[u8]) -> Result<(), String> {
        let update = Update::decode_v1(update_bytes)
            .map_err(|e| format!("Invalid Yrs update blob: {:?}", e))?;
        let mut txn = self.doc.transact_mut();
        txn.apply_update(update);
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_yrs_crdt_delta_generation_and_merge() {
        let sync_a = SyncEngine::new();
        let mut sync_b = SyncEngine::new();

        let delta_a = sync_a.generate_delta_blob();
        assert!(!delta_a.is_empty());

        let result = sync_b.apply_remote_delta(&delta_a);
        assert!(result.is_ok());
    }
}



