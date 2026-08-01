use anyhow::Result;
use rusqlite::Connection;
use crate::models::{Document, HISTBIS_ACTIVE, generate_histvon_timestamp};

pub struct DatabaseEngine {
    conn: Connection,
}

impl DatabaseEngine {
    pub fn new_in_memory() -> Result<Self> {
        let conn = Connection::open_in_memory()?;
        let engine = Self { conn };
        engine.init_schema()?;
        Ok(engine)
    }

    pub fn new(db_path: &str, encryption_key: &str) -> Result<Self> {
        let conn = Connection::open(db_path)?;
        conn.pragma_update(None, "key", encryption_key)?;
        conn.pragma_update(None, "foreign_keys", "ON")?;
        let engine = Self { conn };
        engine.init_schema()?;
        Ok(engine)
    }

    fn init_schema(&self) -> Result<()> {
        self.conn.execute_batch(
            "
            CREATE TABLE IF NOT EXISTS documents (
                id TEXT NOT NULL,
                title TEXT NOT NULL,
                author TEXT,
                file_path TEXT NOT NULL,
                mime_type TEXT NOT NULL,
                word_count INTEGER NOT NULL,
                reading_progress REAL DEFAULT 0.0,
                checksum TEXT NOT NULL,
                histvon TEXT NOT NULL,
                histbis TEXT NOT NULL DEFAULT '9999',
                PRIMARY KEY (id, histvon)
            );

            CREATE TABLE IF NOT EXISTS document_chunks (
                id TEXT NOT NULL,
                document_id TEXT NOT NULL,
                chunk_index INTEGER NOT NULL,
                content TEXT NOT NULL,
                token_count INTEGER NOT NULL,
                complexity_score REAL DEFAULT 1.0,
                histvon TEXT NOT NULL,
                histbis TEXT NOT NULL DEFAULT '9999',
                PRIMARY KEY (id, histvon)
            );

            CREATE TABLE IF NOT EXISTS annotations (
                id TEXT NOT NULL,
                document_id TEXT NOT NULL,
                selected_text TEXT NOT NULL,
                note TEXT,
                color_hex TEXT DEFAULT '#FFD700',
                start_offset INTEGER NOT NULL,
                end_offset INTEGER NOT NULL,
                chapter_index INTEGER DEFAULT 0,
                histvon TEXT NOT NULL,
                histbis TEXT NOT NULL DEFAULT '9999',
                PRIMARY KEY (id, histvon)
            );

            CREATE TABLE IF NOT EXISTS flashcards (
                id TEXT NOT NULL,
                annotation_id TEXT,
                document_id TEXT NOT NULL,
                question TEXT NOT NULL,
                answer TEXT NOT NULL,
                interval INTEGER DEFAULT 1,
                repetition_factor REAL DEFAULT 2.5,
                due_date INTEGER NOT NULL,
                histvon TEXT NOT NULL,
                histbis TEXT NOT NULL DEFAULT '9999',
                PRIMARY KEY (id, histvon)
            );

            CREATE TABLE IF NOT EXISTS sync_crdt_deltas (
                id TEXT PRIMARY KEY NOT NULL,
                entity_name TEXT NOT NULL,
                entity_id TEXT NOT NULL,
                crdt_clock INTEGER NOT NULL,
                delta_blob BLOB NOT NULL,
                histvon TEXT NOT NULL,
                histbis TEXT NOT NULL DEFAULT '9999'
            );
            "
        )?;
        Ok(())
    }

    pub fn get_active_documents(&self) -> Result<Vec<Document>> {
        let mut stmt = self.conn.prepare(
            "SELECT id, title, author, file_path, mime_type, word_count, reading_progress, checksum, histvon, histbis 
             FROM documents WHERE histbis = ?"
        )?;
        
        let docs = stmt.query_map([HISTBIS_ACTIVE], |row| {
            Ok(Document {
                id: row.get(0)?,
                title: row.get(1)?,
                author: row.get(2)?,
                file_path: row.get(3)?,
                mime_type: row.get(4)?,
                word_count: row.get(5)?,
                reading_progress: row.get(6)?,
                checksum: row.get(7)?,
                histvon: row.get(8)?,
                histbis: row.get(9)?,
            })
        })?.collect::<Result<Vec<_>, _>>()?;

        Ok(docs)
    }

    pub fn insert_document(&self, mut doc: Document) -> Result<()> {
        let now = generate_histvon_timestamp();
        doc.histvon = now;
        doc.histbis = HISTBIS_ACTIVE.to_string();

        self.conn.execute(
            "INSERT INTO documents (id, title, author, file_path, mime_type, word_count, reading_progress, checksum, histvon, histbis)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (
                &doc.id,
                &doc.title,
                &doc.author,
                &doc.file_path,
                &doc.mime_type,
                doc.word_count,
                doc.reading_progress,
                &doc.checksum,
                &doc.histvon,
                &doc.histbis,
            ),
        )?;
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_db_init_and_document_insert() -> Result<()> {
        let db = DatabaseEngine::new_in_memory()?;
        
        let doc = Document {
            id: "doc_123".to_string(),
            title: "Test Book".to_string(),
            author: Some("Author Name".to_string()),
            file_path: "/tmp/test.epub".to_string(),
            mime_type: "application/epub+zip".to_string(),
            word_count: 5000,
            reading_progress: 0.25,
            checksum: "abc123checksum".to_string(),
            histvon: String::new(),
            histbis: String::new(),
        };

        db.insert_document(doc)?;

        let docs = db.get_active_documents()?;
        assert_eq!(docs.len(), 1);
        assert_eq!(docs[0].id, "doc_123");
        assert_eq!(docs[0].title, "Test Book");
        assert_eq!(docs[0].histbis, "9999");
        assert_eq!(docs[0].histvon.len(), 17); // 17-char YYYYMMDDHHMMSSSSS timestamp

        Ok(())
    }
}
