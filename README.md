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

The table name is elements and you can run queries using the following SQL:


```sql
SELECT  FROM elements
WHERE embeddings <=> embeddings('your query');
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