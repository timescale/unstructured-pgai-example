# Unstructured TimescaleDB

This is a simple example of how to use Unstructured with TimescaleDB.

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
- `OPENAI_MODEL`: The specific OpenAI model to use (e.g., "gpt-3.5-turbo" or "gpt-4")
- `UNSTRUCTURED_API_KEY`: API key for the Unstructured service (if using the hosted version)
- `MAX_THREADS`: Number of concurrent threads for processing
- `BATCH_SIZE`: Number of documents to process in each batch

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

The table name is elements and you can run queries using the following SQL:


```sql
SELECT  FROM elements
WHERE embeddings <=> embeddings('your query');
```

