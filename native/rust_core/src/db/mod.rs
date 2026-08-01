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

            CREATE TABLE IF NOT EXISTS highlights (
                id TEXT NOT NULL,
                document_id TEXT NOT NULL,
                chunk_id TEXT NOT NULL,
                selected_text TEXT NOT NULL,
                color_hex TEXT NOT NULL,
                note_markdown TEXT,
                histvon TEXT NOT NULL,
                histbis TEXT NOT NULL DEFAULT '9999',
                PRIMARY KEY (id, histvon)
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
