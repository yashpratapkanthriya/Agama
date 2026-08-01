use serde::{Deserialize, Serialize};

pub const HISTBIS_ACTIVE: &str = "9999";

/// Generate 17-character timestamp: YYYYMMDDHHMMSSSSS
pub fn generate_histvon_timestamp() -> String {
    let now = chrono::Utc::now();
    now.format("%Y%m%d%H%M%S").to_string() + &format!("{:03}", now.timestamp_subsec_millis())
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Document {
    pub id: String,
    pub title: String,
    pub author: Option<String>,
    pub file_path: String,
    pub mime_type: String,
    pub word_count: i64,
    pub reading_progress: f64,
    pub checksum: String,
    pub histvon: String,
    pub histbis: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DocumentChunk {
    pub id: String,
    pub document_id: String,
    pub chunk_index: i64,
    pub content: String,
    pub token_count: i64,
    pub complexity_score: f64,
    pub histvon: String,
    pub histbis: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Highlight {
    pub id: String,
    pub document_id: String,
    pub chunk_id: String,
    pub selected_text: String,
    pub color_hex: String,
    pub note_markdown: Option<String>,
    pub histvon: String,
    pub histbis: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WordTiming {
    pub word: String,
    pub delay_ms: u64,
    pub orp_index: usize,
    pub is_punctuation_pause: bool,
}
