#!/bin/bash
set -e
# Change directory to where requirements.txt and code live
cd "$(dirname "$0")"

# Install dependencies if missing
python -m pip install -r requirements.txt

# Run uvicorn via python module invocation
exec python -m uvicorn app:app --host 0.0.0.0 --port 8080

# Port 8080 is standard for Red Hat S2I Python builders
#exec uvicorn app:app --host 0.0.0.0 --port 8080
