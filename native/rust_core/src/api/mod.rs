use crate::ai::AdaptivePacingEngine;
use crate::models::WordTiming;

pub fn generate_rsvp_timings(text: String, target_wpm: u32, paragraph_complexity: f64) -> Vec<WordTiming> {
    let engine = AdaptivePacingEngine::new();
    text.split_whitespace()
        .map(|w| engine.calculate_word_delay(w, target_wpm, paragraph_complexity))
        .collect()
}
