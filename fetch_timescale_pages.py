from unstructured.partition.html import partition_html
import os
import nltk
import psycopg2
from psycopg2.extras import execute_values
from datetime import datetime
import traceback

# nltk.download('punkt')

# Database connection details
DB_HOST = os.getenv('PGHOST')
DB_PORT = os.getenv('PGPORT')
DB_NAME = os.getenv('PGDATABASE')
DB_USER = os.getenv('PGUSER')
DB_PASSWORD = os.getenv('PGPASSWORD')

# Create a connection to the database
conn = psycopg2.connect(
    host=DB_HOST,
    port=DB_PORT,
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD
)

# Create a cursor
cur = conn.cursor()

def process_page(url, visited_links):
    if url in visited_links:
        return

    visited_links.add(url)
    try:
        elements = partition_html(url=url)
        
        # Prepare data for bulk insert
        data = []
        for element in elements:
            element_dict = element.to_dict()
            text = element_dict['text']
            extra = element_dict['metadata']
            
            data.append((
                text,
                element_dict['element_id'],
                url,
                element_dict['type'],
                extra.get('page_name'),
                extra.get('layout_width'),
                extra.get('layout_height'),
                extra.get('points'),
                extra.get('version'),
                extra.get('date_modified'),
                extra.get('date_processed'),
                extra.get('permissions_data'),
                extra.get('record_locator'),
                extra.get('category_depth'),
                extra.get('parent_id'),
                extra.get('attached_filename'),
                extra.get('filetype'),
                extra.get('last_modified'),
                extra.get('file_directory'),
                extra.get('filename'),
                extra.get('page_number'),
                extra.get('links'),
                extra.get('link_urls'),
                extra.get('link_texts'),
                extra.get('sent_from'),
                extra.get('sent_to'),
                extra.get('subject'),
                extra.get('section'),
                extra.get('header_footer_type'),
                extra.get('emphasized_text_contents'),
                extra.get('emphasized_text_tags'),
                extra.get('text_as_html'),
                extra.get('regex_metadata'),
                extra.get('detection_class_prob'),
                extra.get('languages')
            ))
        
        # Bulk insert
        insert_query = """
        INSERT INTO elements (
            text, element_id, url, type, page_name, layout_width, layout_height,
            points, version, date_modified, date_processed, permissions_data,
            record_locator, category_depth, parent_id, attached_filename,
            filetype, last_modified, file_directory, filename, page_number,
            links, link_urls, link_texts, sent_from, sent_to, subject, section,
            header_footer_type, emphasized_text_contents, emphasized_text_tags,
            text_as_html, regex_metadata, detection_class_prob, languages
        ) VALUES %s
        """
        execute_values(cur, insert_query, data)
        conn.commit()
        print(f"Processed and inserted {len(elements)} elements from {url}")

        # Recursively process linked pages
        for element in elements:
            for link in element.metadata.link_urls or []:
                if link.startswith(timescale) or link.startswith("/"):
                    if link.startswith("/") and not link.startswith("/#"):
                        link = timescale + link
                    process_page(link, visited_links)

    except Exception as e:
        print(f"Error processing {url}: {e}")
        print("Stacktrace:")
        traceback.print_exc()
        conn.rollback()

# Main execution
timescale = "https://docs.timescale.com"
visited_links = set()
process_page(timescale, visited_links)

# Close the cursor and connection
cur.close()
conn.close()

print(f"Finished processing. Total pages processed: {len(visited_links)}")