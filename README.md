# Unstructured + pgai + TimescaleDB

This is a simple example of how to use Unstructured with TimescaleDB.

With this setup you can embed any document on your postgresql database and run queries on it.

For now, run.sh just imports the document into TimescaleDB and vectorizes the text from description field.

# Setup

Copy the `.envrc.example` file to `.envrc` and edit it to set the correct environment variables.

```bash
cp .envrc.example .envrc
```

Open `.envrc` and set the correct environment variables. The file includes settings for:

- TimescaleDB connection details
- OpenAI API configuration
- Unstructured API settings
- Other project-specific settings

Make sure to set the following key variables:

- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`: TimescaleDB connection details
- `OPENAI_API_KEY`: Your OpenAI API key for text processing tasks
- `UNSTRUCTURED_API_KEY`: API key for the Unstructured service (if using the hosted version)

You can adapt the openai model or the embedding model to your needs directly in the schema.sql file.

Adjust other settings as needed for your specific use case.

After setting up the environment variables, run `install.sh` to install the necessary dependencies.

Run `run.sh` to import the data into TimescaleDB.

Example:

```bash
./install.sh
./run.sh import/my/file.pdf
```

# Database schema

By default, the database schema is created using the `schema.sql` file.

It creates a table `elements` that includes all the fields that Unstructured can extract from a document.


# Running queries

You can run a semantic search using the following SQL:

```sql
SELECT * FROM elements
ORDER BY embeddings <=> embeddings('your query') LIMIT 10;
```

# Importing data from HTML

You can use the run.sh script to import data from HTML files too.

```bash
./run.sh import/my/file.html
```

In this case, if you don't have data files to play, I recommend you to use the unstructured project that contains a lot of data files to play with.

```
git clone https://github.com/Unstructured-IO/unstructured
```

Then, you can run the following command to import the data from the HTML files:

```bash
./run.sh ../unstructured/example-docs/example-10k.html
```

Now, with a 10k file, it will have an output like this:

```
2024-08-21 15:05:34,322 MainProcess INFO     Created index with configs: {"input_path": "../../unstructured/example-docs/example-10k.html", "recursive": false}, connection configs: {"access_config": "**********"}
2024-08-21 15:05:34,322 MainProcess INFO     Created download with configs: {"download_dir": null}, connection configs: {"access_config": "**********"}
2024-08-21 15:05:34,322 MainProcess INFO     Created filter with configs: {"file_glob": null, "max_file_size": null}
2024-08-21 15:05:34,323 MainProcess INFO     Created partition with configs: {"strategy": "auto", "ocr_languages": null, "encoding": null, "additional_partition_args": {"split_pdf_page": "true", "split_pdf_allow_failed": "true", "split_pdf_concurrency_level": 15}, "skip_infer_table_types": null, "fields_include": ["element_id", "text", "type", "metadata", "embeddings"], "flatten_metadata": false, "metadata_exclude": [], "metadata_include": ["id", "element_id", "text", "embeddings", "type", "system", "layout_width", "layout_height", "points", "url", "version", "date_created", "date_modified", "date_processed", "permissions_data", "record_locator", "category_depth", "parent_id", "attached_filename", "filetype", "last_modified", "file_directory", "filename", "languages", "page_number", "links", "page_name", "link_urls", "link_texts", "sent_from", "sent_to", "subject", "section", "header_footer_type", "emphasized_text_contents", "emphasized_text_tags", "text_as_html", "regex_metadata", "detection_class_prob"], "partition_endpoint": "https://api.unstructured.io/general/v0/general", "partition_by_api": false, "api_key": null, "hi_res_model_name": null}
2024-08-21 15:05:34,323 MainProcess INFO     Created upload_stage with configs: {}
2024-08-21 15:05:34,323 MainProcess INFO     Created upload with configs: {"batch_size": 50}, connection configs: {"access_config": "**********", "db_type": "postgresql", "database": "vector_playground", "host": "localhost", "port": 5432, "connector_type": "sql"}
2024-08-21 15:05:34,391 MainProcess INFO     Running local pipline: index (LocalIndexer) -> filter -> download (LocalDownloader) -> filter -> partition (auto) -> upload_stage (SQLUploadStager) -> upload (SQLUploader) with configs: {"reprocess": false, "verbose": true, "tqdm": false, "work_dir": "data", "num_processes": 2, "max_connections": null, "raise_on_error": false, "disable_parallelism": false, "preserve_downloads": false, "download_only": false, "max_docs": null, "re_download": false, "uncompress": false, "status": {}, "semaphore": null}
2024-08-21 15:05:35,819 MainProcess DEBUG    Generated file data: {"identifier": "/Users/jonatasdp/code/unstructured/example-docs/example-10k.html", "connector_type": "local", "source_identifiers": {"filename": "example-10k.html", "fullpath": "/Users/jonatasdp/code/unstructured/example-docs/example-10k.html", "rel_path": "example-10k.html"}, "doc_type": "file", "metadata": {"url": null, "version": null, "record_locator": {"path": "/Users/jonatasdp/code/unstructured/example-docs/example-10k.html"}, "date_created": "1724179566.867809", "date_modified": "1724179566.8738236", "date_processed": "1724263535.8178291", "permissions_data": [{"mode": 33188}], "filesize_bytes": 2456707}, "additional_metadata": {}, "reprocess": false}
2024-08-21 15:05:35,822 MainProcess INFO     Calling FilterStep with 1 docs
2024-08-21 15:05:35,822 MainProcess INFO     processing content across processes
2024-08-21 15:05:35,822 MainProcess INFO     processing content serially
2024-08-21 15:05:35,824 MainProcess INFO     FilterStep [cls] took 0.002730131149291992 seconds
2024-08-21 15:05:35,824 MainProcess INFO     Calling DownloadStep with 1 docs
2024-08-21 15:05:35,825 MainProcess INFO     processing content async
2024-08-21 15:05:35,826 MainProcess DEBUG    Skipping download, file already exists locally: /Users/jonatasdp/code/unstructured/example-docs/example-10k.html
2024-08-21 15:05:35,826 MainProcess INFO     DownloadStep [cls] took 0.001313924789428711 seconds
2024-08-21 15:05:35,826 MainProcess INFO     Calling FilterStep with 1 docs
2024-08-21 15:05:35,826 MainProcess INFO     processing content across processes
2024-08-21 15:05:35,826 MainProcess INFO     processing content serially
2024-08-21 15:05:35,827 MainProcess INFO     FilterStep [cls] took 0.0011758804321289062 seconds
2024-08-21 15:05:35,827 MainProcess INFO     Calling PartitionStep with 1 docs
2024-08-21 15:05:35,827 MainProcess INFO     processing content across processes
2024-08-21 15:05:35,827 MainProcess INFO     processing content serially
2024-08-21 15:05:35,828 MainProcess DEBUG    Skipping partitioning, output already exists: /Users/jonatasdp/code/timescale/unstructured-timescaledb/data/partition/8323bca93f7c.json
2024-08-21 15:05:35,829 MainProcess INFO     PartitionStep [cls] took 0.001569986343383789 seconds
2024-08-21 15:05:35,829 MainProcess INFO     Calling UploadStageStep with 1 docs
2024-08-21 15:05:35,829 MainProcess INFO     processing content across processes
2024-08-21 15:05:35,829 MainProcess INFO     processing content serially
...
2024-08-21 15:05:35,874 MainProcess INFO     UploadStageStep [cls] took 0.04475522041320801 seconds
2024-08-21 15:05:35,874 MainProcess INFO     Calling UploadStep with 1 docs
2024-08-21 15:05:35,882 MainProcess DEBUG    uploading 313 entries to vector_playground
2024-08-21 15:08:54,376 MainProcess INFO     UploadStep [cls] took 198.50195574760437 seconds
2024-08-21 15:08:54,377 MainProcess INFO     Finished ingest process in 200.0532009601593s
```

:warning: The above output is truncated. Also, note that the skip_download and skip_partition options are set to true, so the partition and download steps are skipped as they're already done.

Now, let's take a look at the data filtering by the `type` field:

```sql
select languages, type, text from elements where type = 'Title' ;
 languages | type  |                                        text
-----------+-------+------------------------------------------------------------------------------------
 {eng}     | Title | UNITED STATES
 {eng}     | Title | SECURITIES AND EXCHANGE COMMISSION
 {eng}     | Title | Washington, D.C. 20549
 {eng}     | Title | FORM
 {eng}     | Title | For the transition period from to
 {eng}     | Title | Commission file number:
 {eng}     | Title | ITEM 1. BUSINESS
 {eng}     | Title | ANNUAL REPORT ON FORM 10-K FOR THE YEAR ENDED DECEMBER 31, 2021
 {eng}     | Title | TABLE OF CONTENTS
 {eng}     | Title | SPECIAL NOTE REGARDING FORWARD-LOOKING STATEMENTS
```


You can also find nearest elements by the embeddings using the `<=>` operator:

```sql
vector_playground=# select type, text from elements order by embeddings <=> embedding('Tax')  limit 10;
       type        |   text
-------------------+--------------------------------------------------------------------------------------------------------
 Title             | FORM
 Title             | BUSINESS
 NarrativeText     | The income tax expense was $48,637 in 2021 based on an effective rate of 2.25 percent compared to the benefit of ($605,936) in 2020 based on an effective rate of 17.42 percent. The 2.25 percent effective tax rate for 2021 differed from the statutory federal income tax rate of 21.0 percent and was primarily attributable to (i) increased tax benefit from the exercise of stock options; (ii) the increased foreign rate differential and (iii) the Company maintaining a valuation allowance against its deferred tax assets.
 UncategorizedText | 11
 Title             | GOVERNMENT REGULATION
 UncategorizedText | 35
 UncategorizedText | 41
 Title             | UNITED STATES
 UncategorizedText | 45
```

The `embeddings` field is the embedding of the text column of the element. And, you can use a semantic search to find the nearest elements to a given embedding.

```sql
vector_playground=# select text from elements where type = 'Title' and embeddings <=> embedding('first day of the year') < 0.2;
                  text
----------------------------------------
 YEARS ENDED December 31, 2021 AND 2020
 YEARS ENDED DECEMBER 31, 2021 AND 2020
 YEARS ENDED DECEMBER 31, 2021 AND 2020
 YEARS ENDED DECEMBER 31, 2021 AND 2020
(4 rows)
```

# Extra resources

- [Unstructured](https://unstructured.io/) is the company behind the Unstructured library.
- [Timescale](https://www.timescale.com/) is the company behind TimescaleDB and pgai extensions.
- [PGVector](https://github.com/pgvector/pgvector) is the vector extension for postgresql.
- [pgai](https://github.com/timescale/pgai) is the ai extension for postgresql that can be used to run queries and create the vector embeddings.

# Contributing

We welcome contributions to improve this project! Here are some ways you can contribute:

1. Report bugs or suggest features by opening an issue.
2. Submit pull requests to fix bugs or add new features.
3. Improve documentation or add examples.
4. Share your experience using the project with others.

Before contributing, please read our contributing guidelines [CONTRIBUTING.md](CONTRIBUTING.md) for more information on our development process, coding standards, and how to submit pull requests.

Thank you for helping make this project better!