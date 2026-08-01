use serde::{Deserialize, Serialize};
use std::sync::atomic::{AtomicU64, Ordering};

pub const HISTBIS_ACTIVE: &str = "9999";

static LAST_TIMESTAMP_MILLIS: AtomicU64 = AtomicU64::new(0);

/// Generate 17-character timestamp: YYYYMMDDHHMMSSSSS with guaranteed monotonic uniqueness
pub fn generate_histvon_timestamp() -> String {
    let now = chrono::Utc::now();
    let current_millis = now.timestamp_millis() as u64;

    let mut last = LAST_TIMESTAMP_MILLIS.load(Ordering::SeqCst);
    loop {
        let next = if current_millis <= last {
            last + 1
        } else {
            current_millis
        };

        match LAST_TIMESTAMP_MILLIS.compare_exchange_weak(
            last,
            next,
            Ordering::SeqCst,
            Ordering::SeqCst,
        ) {
            Ok(_) => {
                let datetime = chrono::DateTime::from_timestamp_millis(next as i64)
                    .unwrap_or(now);
                return datetime.format("%Y%m%d%H%M%S").to_string()
                    + &format!("{:03}", datetime.timestamp_subsec_millis());
            }
            Err(actual) => last = actual,
        }
    }
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
pub struct Annotation {
    pub id: String,
    pub document_id: String,
    pub selected_text: String,
    pub note: Option<String>,
    pub color_hex: String,
    pub start_offset: i64,
    pub end_offset: i64,
    pub chapter_index: i64,
    pub histvon: String,
    pub histbis: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Flashcard {
    pub id: String,
    pub annotation_id: Option<String>,
    pub document_id: String,
    pub question: String,
    pub answer: String,
    pub interval: i64,
    pub repetition_factor: f64,
    pub due_date: i64, // Unix timestamp in seconds
    pub histvon: String,
    pub histbis: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ReadingSession {
    pub id: String,
    pub document_id: String,
    pub start_time: i64,
    pub end_time: i64,
    pub words_read: i64,
    pub avg_wpm: i64,
    pub quiz_score: Option<f64>,
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

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BionicWord {
    pub full_word: String,
    pub prefix: String,
    pub suffix: String,
    pub bold_length: usize,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SearchResult {
    pub chunk_id: String,
    pub document_id: String,
    pub content: String,
    pub score: f64,
}

