#!/usr/bin/env bash

# Specify which fields to output in the processed data. This can help prevent
# database record insert issues, where a particular field in the processed data
# does not match a column in the database table on insert.
metadata_includes="id,element_id,text,embeddings,type,system,layout_width,\
layout_height,points,url,version,date_created,date_modified,date_processed,\
permissions_data,record_locator,category_depth,parent_id,attached_filename,\
filetype,last_modified,file_directory,filename,languages,page_number,links,\
page_name,link_urls,link_texts,sent_from,sent_to,subject,section,\
header_footer_type,emphasized_text_contents,emphasized_text_tags,\
text_as_html,regex_metadata,detection_class_prob"


unstructured-ingest \
  local \
    --input-path "$*" \
    --strategy fast \
    --output-dir local-output-to-SQL \
    --num-processes 2 \
    --verbose \
    --work-dir data \
    --partition-by-api \
    --api-key $UNSTRUCTURED_API_KEY \
    --partition-endpoint $UNSTRUCTURED_API_URL \
    --metadata-include "$metadata_includes" \
    --additional-partition-args="{\"split_pdf_page\":\"true\", \"split_pdf_allow_failed\":\"true\", \"split_pdf_concurrency_level\": 15}" \
  postgres \
    --db-type $SQL_DB_TYPE \
    --username $PGUSER \
    --password $PGPASSWORD \
    --host $PGHOST \
    --port $PGPORT \
    --database $PGDATABASE
