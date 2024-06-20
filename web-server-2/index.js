const express = require("express");
const cors = require("cors");
require("dotenv/config");
const app = express();
const PORT = process.env.PORT || 8000;
app.use(cors());
app.use(express.json());

app.get("/hello", (req, res) => {
  res.send({ message: "Hello ji this is server 2" });
});
app.get("/service2/hello", (req, res) => {
  res.send({ message: "Hello ji this is server 2" });
});

app.listen(PORT, () => {
  console.log("Server 2 is running on port", PORT);
});
