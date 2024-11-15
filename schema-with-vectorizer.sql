CREATE EXTENSION IF NOT EXISTS ai CASCADE;

-- Create the table for the elements (source table)
CREATE TABLE IF NOT EXISTS elements (
    id UUID PRIMARY KEY,
    element_id TEXT,
    text TEXT,
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

-- Create the pgai Vectorizer for the source table
SELECT ai.create_vectorizer(
    'public.elements'::regclass
  , embedding=>ai.embedding_openai('text-embedding-3-small', 1536)
  , chunking=>ai.chunking_recursive_character_text_splitter('text')
  , formatting=>ai.formatting_python_template('type: $type, url: $url, chunk: $chunk')
);
