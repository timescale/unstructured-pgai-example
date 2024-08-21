echo "Installing dependencies..."
pip install -r requirements.txt

echo "Creating schema..."
psql $PG_URI -f schema.sql
