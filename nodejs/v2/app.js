const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

app.get('/books', (req, res) => {
  res.json({
    version: "v2",
    data: [
      { id: 1, title: "The Hobbit", author: "J.R.R. Tolkien", rating: 4.8, inStock: true },
      { id: 2, title: "1984", author: "George Orwell", rating: 4.6, inStock: false }
    ]
  });
});

app.listen(PORT, () => console.log(`v2 service running on port ${PORT}`));
