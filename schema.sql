CREATE EXTENSION IF NOT EXISTS ai CASCADE;

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

CREATE TABLE IF NOT EXISTS elements (
    id UUID,
    element_id TEXT,
    text TEXT,
    embeddings vector GENERATED ALWAYS AS (embedding(text)) STORED,
    type TEXT,
    system TEXT,
    layout_width DECIMAL,
    layout_height DECIMAL,
    points TEXT,
    url TEXT,
    version TEXT,
    date_created TIMESTAMPTZ NOT NULL DEFAULT now(),
    date_modified TIMESTAMPTZ,
    date_processed TIMESTAMPTZ,
    permissions_data TEXT,
    record_locator TEXT,
    category_depth numeric,
    parent_id TEXT,
    attached_filename TEXT,
    filetype TEXT,
    last_modified TIMESTAMPTZ,
    file_directory TEXT,
    filename TEXT,
    languages TEXT [],
    page_number TEXT,
    links TEXT,
    page_name TEXT,
    link_urls TEXT [],
    link_texts TEXT [],
    sent_from TEXT [],
    sent_to TEXT [],
    subject TEXT,
    section TEXT,
    header_footer_type TEXT,
    emphasized_text_contents TEXT [],
    emphasized_text_tags TEXT [],
    text_as_html TEXT,
    regex_metadata TEXT,
    detection_class_prob DECIMAL
);