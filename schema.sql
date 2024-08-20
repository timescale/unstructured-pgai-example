CREATE EXTENSION IF NOT EXISTS ai CASCADE;

DROP TABLE IF EXISTS elements CASCADE;

-- Create or replace the function to embed content
CREATE OR REPLACE FUNCTION embedding(content TEXT) RETURNS VECTOR AS $$
DECLARE
    vectorized_content VECTOR;
BEGIN
    vectorized_content := openai_embed(
        'text-embedding-ada-002',
        content
    )::VECTOR;
    RETURN vectorized_content;
END;
$$ IMMUTABLE LANGUAGE plpgsql;


CREATE TABLE elements (
    id UUID PRIMARY KEY,
    element_id VARCHAR,
    text TEXT,
    embeddings vector GENERATED ALWAYS AS (embedding(text)) STORED,
    type VARCHAR,
    system VARCHAR,
    layout_width DECIMAL,
    layout_height DECIMAL,
    points TEXT,
    url TEXT,
    version VARCHAR,
    date_created TIMESTAMPTZ,
    date_modified TIMESTAMPTZ,
    date_processed TIMESTAMPTZ,
    permissions_data TEXT,
    record_locator TEXT,
    category_depth INTEGER,
    parent_id VARCHAR,
    attached_filename VARCHAR,
    filetype VARCHAR,
    last_modified TIMESTAMPTZ,
    file_directory VARCHAR,
    filename VARCHAR,
    languages VARCHAR [],
    page_number VARCHAR,
    links TEXT,
    page_name VARCHAR,
    link_urls VARCHAR [],
    link_texts VARCHAR [],
    sent_from VARCHAR [],
    sent_to VARCHAR [],
    subject VARCHAR,
    section VARCHAR,
    header_footer_type VARCHAR,
    emphasized_text_contents VARCHAR [],
    emphasized_text_tags VARCHAR [],
    text_as_html TEXT,
    regex_metadata TEXT,
    detection_class_prob DECIMAL
);

