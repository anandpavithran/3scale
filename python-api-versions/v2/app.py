from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/books")
def get_books():
    return {
        "version": "v2",
        "data": [
            {
                "id": 1,
                "title": "The Hobbit",
                "author": "J.R.R. Tolkien",
                "rating": 4.8,
                "inStock": True
            },
            {
                "id": 2,
                "title": "1984",
                "author": "George Orwell",
                "rating": 4.6,
                "inStock": False
            }
        ]
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)
