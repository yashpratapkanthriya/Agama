use anyhow::Result;
use rusqlite::Connection;
use crate::models::{
    Annotation, Document, Flashcard, ReadingSession,
    HISTBIS_ACTIVE, generate_histvon_timestamp,
};
use crate::ai::SpacedRepetitionEngine;


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

            CREATE TABLE IF NOT EXISTS reading_sessions (
                id TEXT NOT NULL,
                document_id TEXT NOT NULL,
                start_time INTEGER NOT NULL,
                end_time INTEGER NOT NULL,
                words_read INTEGER NOT NULL,
                avg_wpm INTEGER NOT NULL,
                quiz_score REAL,
                histvon TEXT NOT NULL,
                histbis TEXT NOT NULL DEFAULT '9999',
                PRIMARY KEY (id, histvon)
            );

            CREATE INDEX IF NOT EXISTS idx_docs_active ON documents(id) WHERE histbis = '9999';
            CREATE INDEX IF NOT EXISTS idx_chunks_active ON document_chunks(document_id, chunk_index) WHERE histbis = '9999';
            CREATE INDEX IF NOT EXISTS idx_annotations_active ON annotations(document_id) WHERE histbis = '9999';
            CREATE INDEX IF NOT EXISTS idx_flashcards_active ON flashcards(due_date) WHERE histbis = '9999';
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

    pub fn insert_annotation(&self, mut ann: Annotation) -> Result<()> {
        let now = generate_histvon_timestamp();
        ann.histvon = now;
        ann.histbis = HISTBIS_ACTIVE.to_string();

        self.conn.execute(
            "INSERT INTO annotations (id, document_id, selected_text, note, color_hex, start_offset, end_offset, chapter_index, histvon, histbis)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (
                &ann.id,
                &ann.document_id,
                &ann.selected_text,
                &ann.note,
                &ann.color_hex,
                ann.start_offset,
                ann.end_offset,
                ann.chapter_index,
                &ann.histvon,
                &ann.histbis,
            ),
        )?;
        Ok(())
    }

    pub fn get_active_annotations(&self, document_id: &str) -> Result<Vec<Annotation>> {
        let mut stmt = self.conn.prepare(
            "SELECT id, document_id, selected_text, note, color_hex, start_offset, end_offset, chapter_index, histvon, histbis
             FROM annotations WHERE document_id = ? AND histbis = ?"
        )?;

        let anns = stmt.query_map([document_id, HISTBIS_ACTIVE], |row| {
            Ok(Annotation {
                id: row.get(0)?,
                document_id: row.get(1)?,
                selected_text: row.get(2)?,
                note: row.get(3)?,
                color_hex: row.get(4)?,
                start_offset: row.get(5)?,
                end_offset: row.get(6)?,
                chapter_index: row.get(7)?,
                histvon: row.get(8)?,
                histbis: row.get(9)?,
            })
        })?.collect::<Result<Vec<_>, _>>()?;

        Ok(anns)
    }

    pub fn insert_flashcard(&self, mut card: Flashcard) -> Result<()> {
        let now = generate_histvon_timestamp();
        card.histvon = now;
        card.histbis = HISTBIS_ACTIVE.to_string();

        self.conn.execute(
            "INSERT INTO flashcards (id, annotation_id, document_id, question, answer, interval, repetition_factor, due_date, histvon, histbis)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (
                &card.id,
                &card.annotation_id,
                &card.document_id,
                &card.question,
                &card.answer,
                card.interval,
                card.repetition_factor,
                card.due_date,
                &card.histvon,
                &card.histbis,
            ),
        )?;
        Ok(())
    }

    pub fn get_due_flashcards(&self, current_time_sec: i64) -> Result<Vec<Flashcard>> {
        let mut stmt = self.conn.prepare(
            "SELECT id, annotation_id, document_id, question, answer, interval, repetition_factor, due_date, histvon, histbis
             FROM flashcards WHERE due_date <= ? AND histbis = ?"
        )?;

        let cards = stmt.query_map((current_time_sec, HISTBIS_ACTIVE), |row| {
            Ok(Flashcard {
                id: row.get(0)?,
                annotation_id: row.get(1)?,
                document_id: row.get(2)?,
                question: row.get(3)?,
                answer: row.get(4)?,
                interval: row.get(5)?,
                repetition_factor: row.get(6)?,
                due_date: row.get(7)?,
                histvon: row.get(8)?,
                histbis: row.get(9)?,
            })
        })?.collect::<Result<Vec<_>, _>>()?;

        Ok(cards)
    }

    pub fn record_flashcard_review(
        &self,
        card_id: &str,
        quality: u8,
        current_time_sec: i64,
    ) -> Result<Flashcard> {
        let now = generate_histvon_timestamp();

        // 1. Deactivate old active card
        self.conn.execute(
            "UPDATE flashcards SET histbis = ? WHERE id = ? AND histbis = ?",
            (&now, card_id, HISTBIS_ACTIVE),
        )?;

        // 2. Query old card parameters
        let mut stmt = self.conn.prepare(
            "SELECT annotation_id, document_id, question, answer, interval, repetition_factor FROM flashcards WHERE id = ? ORDER BY histvon DESC LIMIT 1"
        )?;

        let (ann_id, doc_id, question, answer, old_interval, old_ef): (Option<String>, String, String, String, i64, f64) =
            stmt.query_row([card_id], |r| Ok((r.get(0)?, r.get(1)?, r.get(2)?, r.get(3)?, r.get(4)?, r.get(5)?)))?;

        let (new_interval, new_ef, new_due) = SpacedRepetitionEngine::calculate_sm2(
            quality, old_interval, old_ef, current_time_sec,
        );

        let new_card = Flashcard {
            id: card_id.to_string(),
            annotation_id: ann_id,
            document_id: doc_id,
            question,
            answer,
            interval: new_interval,
            repetition_factor: new_ef,
            due_date: new_due,
            histvon: now.clone(),
            histbis: HISTBIS_ACTIVE.to_string(),
        };

        self.conn.execute(
            "INSERT INTO flashcards (id, annotation_id, document_id, question, answer, interval, repetition_factor, due_date, histvon, histbis)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (
                &new_card.id,
                &new_card.annotation_id,
                &new_card.document_id,
                &new_card.question,
                &new_card.answer,
                new_card.interval,
                new_card.repetition_factor,
                new_card.due_date,
                &new_card.histvon,
                &new_card.histbis,
            ),
        )?;

        Ok(new_card)
    }

    pub fn insert_reading_session(&self, mut session: ReadingSession) -> Result<()> {
        let now = generate_histvon_timestamp();
        session.histvon = now;
        session.histbis = HISTBIS_ACTIVE.to_string();

        self.conn.execute(
            "INSERT INTO reading_sessions (id, document_id, start_time, end_time, words_read, avg_wpm, quiz_score, histvon, histbis)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (
                &session.id,
                &session.document_id,
                session.start_time,
                session.end_time,
                session.words_read,
                session.avg_wpm,
                session.quiz_score,
                &session.histvon,
                &session.histbis,
            ),
        )?;
        Ok(())
    }

    pub fn get_reading_sessions(&self, document_id: &str) -> Result<Vec<ReadingSession>> {
        let mut stmt = self.conn.prepare(
            "SELECT id, document_id, start_time, end_time, words_read, avg_wpm, quiz_score, histvon, histbis
             FROM reading_sessions WHERE document_id = ? AND histbis = ?"
        )?;

        let sessions = stmt.query_map([document_id, HISTBIS_ACTIVE], |row| {
            Ok(ReadingSession {
                id: row.get(0)?,
                document_id: row.get(1)?,
                start_time: row.get(2)?,
                end_time: row.get(3)?,
                words_read: row.get(4)?,
                avg_wpm: row.get(5)?,
                quiz_score: row.get(6)?,
                histvon: row.get(7)?,
                histbis: row.get(8)?,
            })
        })?.collect::<Result<Vec<_>, _>>()?;

        Ok(sessions)
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

    #[test]
    fn test_annotations_and_flashcards_historization() -> Result<()> {
        let db = DatabaseEngine::new_in_memory()?;

        let ann = Annotation {
            id: "ann_1".to_string(),
            document_id: "doc_123".to_string(),
            selected_text: "High contrast reading".to_string(),
            note: Some("Important concept".to_string()),
            color_hex: "#FFD700".to_string(),
            start_offset: 10,
            end_offset: 31,
            chapter_index: 1,
            histvon: String::new(),
            histbis: String::new(),
        };
        db.insert_annotation(ann)?;

        let active_anns = db.get_active_annotations("doc_123")?;
        assert_eq!(active_anns.len(), 1);
        assert_eq!(active_anns[0].selected_text, "High contrast reading");

        let card = Flashcard {
            id: "card_1".to_string(),
            annotation_id: Some("ann_1".to_string()),
            document_id: "doc_123".to_string(),
            question: "What is Agama?".to_string(),
            answer: "Zero-backend AI speed reader".to_string(),
            interval: 1,
            repetition_factor: 2.5,
            due_date: 1000,
            histvon: String::new(),
            histbis: String::new(),
        };
        db.insert_flashcard(card)?;

        let due = db.get_due_flashcards(1500)?;
        assert_eq!(due.len(), 1);

        let updated_card = db.record_flashcard_review("card_1", 4, 1500)?;
        assert_eq!(updated_card.interval, 6);
        assert_eq!(updated_card.histbis, "9999");

        Ok(())
    }
}

