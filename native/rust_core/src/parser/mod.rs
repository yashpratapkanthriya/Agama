use anyhow::Result;

pub struct ParsedDocument {
    pub title: String,
    pub author: Option<String>,
    pub chunks: Vec<String>,
    pub word_count: usize,
}

pub trait DocumentParser {
    fn parse_file(path: &str) -> Result<ParsedDocument>;
}

pub struct TextParser;

impl DocumentParser for TextParser {
    fn parse_file(path: &str) -> Result<ParsedDocument> {
        let content = std::fs::read_to_string(path)?;
        let chunks: Vec<String> = content
            .split("\n\n")
            .map(|s| s.trim().to_string())
            .filter(|s| !s.is_empty())
            .collect();

        let word_count = content.split_whitespace().count();

        Ok(ParsedDocument {
            title: std::path::Path::new(path)
                .file_stem()
                .and_then(|s| s.to_str())
                .unwrap_or("Untitled")
                .to_string(),
            author: None,
            chunks,
            word_count,
        })
    }
}
