const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

app.get('/books', (req, res) => {
  res.json({
    version: "v1",
    data: [
      { id: 1, title: "The Hobbit", author: "J.R.R. Tolkien" },
      { id: 2, title: "1984", author: "George Orwell" }
    ]
  });
});

app.listen(PORT, () => console.log(`v1 service running on port ${PORT}`));
