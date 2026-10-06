
from fastapi import FastAPI
import uvicorn

app = FastAPI()
@app.get("/")
@app.get("/books")
def get_books():
    return {
        "version": "v1",
        "data": [
            {"id": 1, "title": "The Hobbit", "author": "J.R.R. Tolkien"},
            {"id": 2, "title": "1984", "author": "George Orwell"}
        ]
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)
