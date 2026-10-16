from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel
from typing import List, Optional
import os
import socket

app = FastAPI(
    title="Demo Service",
    version="1.0.0",
    docs_url="/docs",
    openapi_url="/openapi.json"
)

class Item(BaseModel):
    id: int
    name: str
    description: Optional[str] = None

# In-memory storage for testing
items_db: List[Item] = [
    Item(id=1, name="Widget", description="Standard utility component"),
    Item(id=2, name="Connector", description="APIcast gateway link")
]

@app.get("/")
def get_root():
    return {
        "status": "online",
        "service": "demo-backend",
        "hostname": socket.gethostname(),
        "environment": os.getenv("APP_ENV", "production")
    }

@app.get("/healthz", status_code=status.HTTP_200_OK)
def health_check():
    return {"status": "healthy"}

@app.get("/items", response_model=List[Item])
def get_items():
    return items_db

@app.post("/items", response_model=Item, status_code=status.HTTP_201_CREATED)
def create_item(item: Item):
    for existing in items_db:
        if existing.id == item.id:
            raise HTTPException(status_code=400, detail="Item ID already exists")
    items_db.append(item)
    return item
