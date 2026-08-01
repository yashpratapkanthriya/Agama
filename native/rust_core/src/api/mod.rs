use crate::ai::{AdaptivePacingEngine, BionicFixationEngine, SpacedRepetitionEngine};
use crate::models::{BionicWord, WordTiming};

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


