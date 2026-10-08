from flask import Flask, jsonify, render_template_string, request

app = Flask(__name__)

# Sample book catalog
BOOKS = [
    {
        "id": 1,
        "title": "Designing Data-Intensive Applications",
        "author": "Martin Kleppmann",
        "isbn": "978-1449373320",
        "category": "Architecture"
    },
    {
        "id": 2,
        "title": "Kubernetes Patterns",
        "author": "Bilgin Ibryam & Roland Huß",
        "isbn": "978-1492050285",
        "category": "Cloud & Containers"
    },
    {
        "id": 3,
        "title": "Quantum Computation and Quantum Information",
        "author": "Michael A. Nielsen & Isaac L. Chuang",
        "isbn": "978-1107002173",
        "category": "Quantum Computing"
    },
    {
        "id": 4,
        "title": "OpenShift in Action",
        "author": "John Morello",
        "isbn": "978-1617294839",
        "category": "DevOps"
    }
]

HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Book Directory & API</title>
  <style>
    :root {
      --bg: #0f172a;
      --card-bg: #1e293b;
      --text: #f8fafc;
      --text-muted: #94a3b8;
      --accent: #38bdf8;
      --border: #334155;
      --badge-bg: #0369a1;
    }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      background: var(--bg);
      color: var(--text);
      margin: 0;
      padding: 2rem 1rem;
      display: flex;
      justify-content: center;
    }
    .container {
      max-width: 860px;
      width: 100%;
    }
    header {
      margin-bottom: 2rem;
      border-bottom: 1px solid var(--border);
      padding-bottom: 1.5rem;
    }
    h1 {
      margin: 0 0 0.5rem 0;
      font-size: 1.75rem;
    }
    .api-badge {
      display: inline-block;
      font-size: 0.85rem;
      background: #1e1e2e;
      border: 1px solid var(--border);
      padding: 0.35rem 0.75rem;
      border-radius: 6px;
      color: var(--accent);
      text-decoration: none;
      font-family: monospace;
    }
    .search-box {
      width: 100%;
      padding: 0.75rem 1rem;
      border-radius: 8px;
      border: 1px solid var(--border);
      background: var(--card-bg);
      color: #fff;
      font-size: 1rem;
      box-sizing: border-box;
      margin-bottom: 1.5rem;
    }
    .book-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
      gap: 1rem;
    }
    .book-card {
      background: var(--card-bg);
      border: 1px solid var(--border);
      border-radius: 8px;
      padding: 1.25rem;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
    }
    .book-title {
      font-weight: 600;
      font-size: 1.1rem;
      margin-bottom: 0.5rem;
    }
    .book-author {
      color: var(--text-muted);
      font-size: 0.9rem;
      margin-bottom: 0.75rem;
    }
    .badge {
      align-self: flex-start;
      background: var(--badge-bg);
      font-size: 0.75rem;
      padding: 0.2rem 0.5rem;
      border-radius: 4px;
      color: #fff;
    }
    .isbn {
      margin-top: 1rem;
      font-size: 0.75rem;
      color: var(--text-muted);
      font-family: monospace;
    }
  </style>
</head>
<body>
  <div class="container">
    <header>
      <h1>Library Catalog</h1>
      <p style="color: var(--text-muted); margin-bottom: 0.75rem;">
        Web interface with dual-mode API support.
      </p>
      <a class="api-badge" href="/api/books" target="_blank">GET /api/books &rarr;</a>
    </header>

    <input type="text" id="searchInput" class="search-box" placeholder="Filter books by title or author..." onkeyup="filterBooks()" />

    <div class="book-grid" id="bookGrid">
      {% for book in books %}
      <div class="book-card" data-title="{{ book.title | lower }}" data-author="{{ book.author | lower }}">
        <div>
          <div class="book-title">{{ book.title }}</div>
          <div class="book-author">by {{ book.author }}</div>
          <span class="badge">{{ book.category }}</span>
        </div>
        <div class="isbn">ISBN: {{ book.isbn }}</div>
      </div>
      {% endfor %}
    </div>
  </div>

  <script>
    function filterBooks() {
      const q = document.getElementById('searchInput').value.toLowerCase();
      const cards = document.querySelectorAll('.book-card');
      cards.forEach(card => {
        const title = card.getAttribute('data-title');
        const author = card.getAttribute('data-author');
        if (title.includes(q) || author.includes(q)) {
          card.style.display = 'flex';
        } else {
          card.style.display = 'none';
        }
      });
    }
  </script>
</body>
</html>
"""

@app.route("/", methods=["GET"])
def index():
    return render_template_string(HTML_TEMPLATE, books=BOOKS)

@app.route("/api/books", methods=["GET"])
def get_books():
    category = request.args.get("category")
    if category:
        filtered = [b for b in BOOKS if b["category"].lower() == category.lower()]
        return jsonify(filtered)
    return jsonify(BOOKS)

@app.route("/healthz", methods=["GET"])
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
