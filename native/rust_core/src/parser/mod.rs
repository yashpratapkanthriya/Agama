use anyhow::{Context, Result};
use std::path::Path;

#[derive(Debug, Clone)]
pub struct ParsedDocument {
    pub title: String,
    pub author: Option<String>,
    pub chunks: Vec<String>,
    pub word_count: usize,
    pub mime_type: String,
}

pub trait DocumentParser {
    fn parse_file(path: &str) -> Result<ParsedDocument>;
}

pub struct TextParser;

impl DocumentParser for TextParser {
    fn parse_file(path: &str) -> Result<ParsedDocument> {
        let content = std::fs::read_to_string(path)
            .with_context(|| format!("Failed to read text file at {}", path))?;
        
        let chunks: Vec<String> = content
            .split("\n\n")
            .map(|s| s.trim().to_string())
            .filter(|s| !s.is_empty())
            .collect();

        let word_count = content.split_whitespace().count();

        let title = Path::new(path)
            .file_stem()
            .and_then(|s| s.to_str())
            .unwrap_or("Untitled")
            .to_string();

        Ok(ParsedDocument {
            title,
            author: None,
            chunks,
            word_count,
            mime_type: "text/plain".to_string(),
        })
    }
}

pub struct EpubParser;

impl DocumentParser for EpubParser {
    fn parse_file(path: &str) -> Result<ParsedDocument> {
        let doc = epub_parser::Epub::parse(Path::new(path))
            .map_err(|e| anyhow::anyhow!("EPUB parse error: {:?}", e))?;
        
        let title = doc.metadata.title.clone().unwrap_or_else(|| "Untitled EPUB".to_string());
        let author = doc.metadata.author.clone();

        let mut chunks = Vec::new();
        let mut total_words = 0;

        for page in &doc.pages {
            let paragraph = page.content.trim();
            if !paragraph.is_empty() {
                total_words += paragraph.split_whitespace().count();
                chunks.push(paragraph.to_string());
            }
        }

        Ok(ParsedDocument {
            title,
            author,
            chunks,
            word_count: total_words,
            mime_type: "application/epub+zip".to_string(),
        })
    }
}

pub struct UnifiedParser;

impl UnifiedParser {
    pub fn parse(path: &str) -> Result<ParsedDocument> {
        let ext = Path::new(path)
            .extension()
            .and_then(|e| e.to_str())
            .unwrap_or("")
            .to_lowercase();

        match ext.as_str() {
            "epub" => EpubParser::parse_file(path),
            _ => TextParser::parse_file(path),
        }
    }
}
