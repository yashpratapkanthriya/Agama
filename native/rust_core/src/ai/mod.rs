use crate::models::WordTiming;

pub struct AdaptivePacingEngine {
    pub alpha_saccade_penalty: f64,
}

impl Default for AdaptivePacingEngine {
    fn default() -> Self {
        Self {
            alpha_saccade_penalty: 0.08,
        }
    }
}

impl AdaptivePacingEngine {
    pub fn new() -> Self {
        Self::default()
    }

    /// Calculate Optimal Recognition Point (ORP) index (approx 35% into word prefix)
    pub fn calculate_orp(word: &str) -> usize {
        let len = word.chars().count();
        match len {
            0 => 0,
            1 => 0,
            2..=5 => 1,
            6..=9 => 2,
            10..=13 => 3,
            _ => 4,
        }
    }

    /// Calculate word timing delay using AIP formula
    pub fn calculate_word_delay(
        &self,
        word: &str,
        target_wpm: u32,
        paragraph_complexity: f64,
    ) -> WordTiming {
        let base_delay_ms = 60_000.0 / (target_wpm as f64);
        let word_len = word.chars().count();
        let length_penalty = 1.0 + self.alpha_saccade_penalty * (word_len.saturating_sub(6) as f64);
        
        let mut total_delay = base_delay_ms * paragraph_complexity * length_penalty;
        
        let mut is_punctuation = false;
        if word.ends_with('.') || word.ends_with('!') || word.ends_with('?') {
            total_delay += 350.0;
            is_punctuation = true;
        } else if word.ends_with(',') || word.ends_with(';') || word.ends_with(':') {
            total_delay += 150.0;
            is_punctuation = true;
        }

        WordTiming {
            word: word.to_string(),
            delay_ms: total_delay.round() as u64,
            orp_index: Self::calculate_orp(word),
            is_punctuation_pause: is_punctuation,
        }
    }
}
