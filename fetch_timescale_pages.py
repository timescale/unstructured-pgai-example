from unstructured.partition.html import partition_html
import os
import urllib.parse
import nltk
import psycopg2
from psycopg2.extras import execute_values
from datetime import datetime
import traceback

# nltk.download('punkt')

# Database connection details
PG_URI = os.getenv('PG_URI')

# Create a connection to the database
conn = psycopg2.connect(PG_URI)

# Create a cursor
cur = conn.cursor()

# Fetch all distinct URLs from the database
cur.execute("SELECT DISTINCT url FROM elements")
visited_links = set(url[0] for url in cur.fetchall())


def process_page(url, visited_links):
    # Avoid processing URLs with '#'
    if '#' in url:
        return

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
                if link.startswith(url) or link.startswith("/"):
                    if link.startswith("/"):
                        link = base_url+ link
                    # Avoid processing URLs with '#'
                    if '#' not in link:
                        encoded_link = urllib.parse.quote(link, safe=':/')
                        process_page(encoded_link, visited_links)

    except Exception as e:
        print(f"Error processing {url}: {e}")
        conn.rollback()

# Main execution
import sys

default_url = "https://docs.timescale.com"
base_url = sys.argv[1] if len(sys.argv) > 1 else default_url
if base_url in visited_links:
    process_page(base_url, visited_links)
else:
    process_page(visited_links[-1], visited_links)

# Close the cursor and connection
cur.close()
conn.close()

print(f"Finished processing. Total pages processed: {len(visited_links)}")
