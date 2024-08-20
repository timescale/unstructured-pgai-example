echo "Installing dependencies..."
pip install "unstructured[all-docs]"
pip install unstructured-ingest
pip install "unstructured-ingest[postgresql]"
pip install direnv


direnv allow

echo "Creating schema..."
psql $PG_URI -f schema.sql


