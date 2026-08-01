use crate::ai::{AdaptivePacingEngine, BionicFixationEngine, SpacedRepetitionEngine};
use crate::models::{BionicWord, WordTiming};
use crate::parser::{ParsedDocument, UnifiedParser};

pub fn generate_rsvp_timings(text: String, target_wpm: u32, paragraph_complexity: f64) -> Vec<WordTiming> {
    let engine = AdaptivePacingEngine::new();
    text.split_whitespace()
        .map(|w| engine.calculate_word_delay(w, target_wpm, paragraph_complexity))
        .collect()
}

pub fn generate_bionic_words(text: String, level: u8) -> Vec<BionicWord> {
    BionicFixationEngine::format_text(&text, level)
}

pub fn calculate_sm2_review(quality: u8, current_interval: i64, current_ef: f64, current_time_sec: i64) -> (i64, f64, i64) {
    SpacedRepetitionEngine::calculate_sm2(quality, current_interval, current_ef, current_time_sec)
}

pub fn stream_rsvp_timings(text: String, target_wpm: u32, paragraph_complexity: f64) -> Vec<WordTiming> {
    generate_rsvp_timings(text, target_wpm, paragraph_complexity)
}

pub fn calculate_cci_score(avg_wpm: i64, quiz_accuracy_fraction: f64) -> f64 {
    (avg_wpm as f64) * quiz_accuracy_fraction.clamp(0.0, 1.0)
}

pub fn calculate_orp_index(word: String) -> usize {
    AdaptivePacingEngine::calculate_orp(&word)
}

pub fn parse_file(path: String) -> anyhow::Result<ParsedDocument> {
    UnifiedParser::parse(&path)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_file_text() {
        let temp_dir = std::env::temp_dir();
        let file_id = std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos();
        let file_path = temp_dir.join(format!("test_api_parse_{}.txt", file_id));
        std::fs::write(&file_path, "Hello world\n\nSecond paragraph").unwrap();

        struct Cleanup(std::path::PathBuf);
        impl Drop for Cleanup {
            fn drop(&mut self) {
                let _ = std::fs::remove_file(&self.0);
            }
        }
        let _cleanup = Cleanup(file_path.clone());

        let res = parse_file(file_path.to_str().unwrap().to_string());
        assert!(res.is_ok());
        let doc = res.unwrap();
        assert_eq!(doc.title, format!("test_api_parse_{}", file_id));
        assert_eq!(doc.chunks.len(), 2);
    }
}





