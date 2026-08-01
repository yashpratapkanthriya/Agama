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

    /// Estimate paragraph syntactical complexity C in range [0.5, 2.0]
    pub fn calculate_complexity_score(text: &str) -> f64 {
        let words: Vec<&str> = text.split_whitespace().collect();
        if words.is_empty() {
            return 1.0;
        }

        let total_chars: usize = words.iter().map(|w| w.len()).sum();
        let avg_word_len = total_chars as f64 / words.len() as f64;

        let comma_count = text.matches(',').count() + text.matches(';').count();
        let punctuation_density = comma_count as f64 / words.len() as f64;

        // Base score from word length and sentence structure
        let score = 1.0 + (avg_word_len - 5.0) * 0.1 + punctuation_density * 0.5;
        score.clamp(0.5, 2.0)
    }

    /// Calculate word timing delay using AIP formula:
    /// t_delay = (60000 / W_target) * C * (1 + alpha * max(0, L - 6)) + punctuation_pauses
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

    /// Generate 384-dimensional dense vector embeddings for sqlite-vec
    pub fn generate_embedding(text: &str) -> Vec<f32> {
        let mut vector = vec![0.0f32; 384];
        let bytes = text.as_bytes();
        for (i, b) in bytes.iter().enumerate() {
            vector[i % 384] += (*b as f32) / 255.0;
        }
        // Normalize vector to unit length
        let norm: f32 = vector.iter().map(|x| x * x).sum::<f32>().sqrt();
        if norm > 0.0 {
            for val in vector.iter_mut() {
                *val /= norm;
            }
        }
        vector
    }
}

pub struct BionicFixationEngine;

impl BionicFixationEngine {
    /// Calculate Bionic Fixation word bold prefix based on level F1..F5 (30% to 70%)
    pub fn calculate_bionic_word(word: &str, level: u8) -> crate::models::BionicWord {
        let len = word.chars().count();
        if len == 0 {
            return crate::models::BionicWord {
                full_word: String::new(),
                prefix: String::new(),
                suffix: String::new(),
                bold_length: 0,
            };
        }

        let ratio = match level.clamp(1, 5) {
            1 => 0.30,
            2 => 0.40,
            3 => 0.50,
            4 => 0.60,
            5 => 0.70,
            _ => 0.40,
        };

        let bold_len = ((len as f64) * ratio).ceil() as usize;
        let bold_len = bold_len.clamp(1, len);

        let prefix: String = word.chars().take(bold_len).collect();
        let suffix: String = word.chars().skip(bold_len).collect();

        crate::models::BionicWord {
            full_word: word.to_string(),
            prefix,
            suffix,
            bold_length: bold_len,
        }
    }

    pub fn format_text(text: &str, level: u8) -> Vec<crate::models::BionicWord> {
        text.split_whitespace()
            .map(|w| Self::calculate_bionic_word(w, level))
            .collect()
    }
}

pub struct SpacedRepetitionEngine;

impl SpacedRepetitionEngine {
    /// SuperMemo SM-2 Spaced Repetition Algorithm
    /// quality q in [0..5]
    /// Returns (new_interval_days, new_repetition_factor, due_date_timestamp_sec)
    pub fn calculate_sm2(
        quality: u8,
        current_interval: i64,
        current_ef: f64,
        current_time_sec: i64,
    ) -> (i64, f64, i64) {
        let q = quality.clamp(0, 5) as f64;
        let new_ef = current_ef + (0.1 - (5.0 - q) * (0.08 + (5.0 - q) * 0.02));
        let new_ef = new_ef.max(1.3);

        let new_interval = if q < 3.0 {
            1
        } else if current_interval <= 1 {
            6
        } else {
            ((current_interval as f64) * new_ef).round() as i64
        };

        let due_date = current_time_sec + new_interval * 86400;
        (new_interval, new_ef, due_date)
    }
}

pub struct OnnxInferenceEngine;

impl OnnxInferenceEngine {
    pub fn infer_complexity(text: &str) -> f64 {
        AdaptivePacingEngine::calculate_complexity_score(text)
    }

    pub fn generate_embedding(text: &str) -> Vec<f32> {
        AdaptivePacingEngine::generate_embedding(text)
    }
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_orp_calculation() {
        assert_eq!(AdaptivePacingEngine::calculate_orp("a"), 0);
        assert_eq!(AdaptivePacingEngine::calculate_orp("read"), 1);
        assert_eq!(AdaptivePacingEngine::calculate_orp("building"), 2);
        assert_eq!(AdaptivePacingEngine::calculate_orp("architecture"), 3);
    }

    #[test]
    fn test_word_delay_calculation() {
        let engine = AdaptivePacingEngine::new();
        let timing = engine.calculate_word_delay("hello.", 600, 1.0);
        assert!(timing.is_punctuation_pause);
        assert_eq!(timing.word, "hello.");
        assert!(timing.delay_ms >= 450);
    }

    #[test]
    fn test_complexity_and_embedding() {
        let score = AdaptivePacingEngine::calculate_complexity_score("Scientific quantum mechanics, thermodynamics, and astrophysics.");
        assert!(score >= 1.0 && score <= 2.0);

        let emb = AdaptivePacingEngine::generate_embedding("Agama speed reading platform");
        assert_eq!(emb.len(), 384);
        
        let norm: f32 = emb.iter().map(|x| x * x).sum::<f32>().sqrt();
        assert!((norm - 1.0).abs() < 1e-4);
    }

    #[test]
    fn test_bionic_fixation() {
        let bw = BionicFixationEngine::calculate_bionic_word("understanding", 3);
        assert_eq!(bw.prefix, "underst");
        assert_eq!(bw.suffix, "anding");
    }

    #[test]
    fn test_sm2_algorithm() {
        let (interval, ef, due) = SpacedRepetitionEngine::calculate_sm2(4, 1, 2.5, 100000);
        assert_eq!(interval, 6);
        assert!(ef >= 2.5);
        assert_eq!(due, 100000 + 6 * 86400);
    }
}

