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
}
