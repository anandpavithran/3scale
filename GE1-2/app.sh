#!/bin/bash
set -e
## Port 8080 is standard for Red Hat S2I Python builders
exec uvicorn app:app --host 0.0.0.0 --port 8080
