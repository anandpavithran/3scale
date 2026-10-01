from fastapi import FastAPI
import socket
import os

app = FastAPI(title="Simple API Service")

@app.get("/")
def read_root():
    return {
        "status": "ok",
        "message": "API is running",
        "hostname": socket.gethostname(),
        "environment": os.getenv("APP_ENV", "production")
    }

@app.get("/healthz")
def health_check():
    return {"status": "healthy"}
