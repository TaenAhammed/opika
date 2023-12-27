const express = require("express");
const axios = require("axios");
const app = express();
app.use(express.json());

const port = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.send("Hello from the Node.js service!");
});

app.post("/sort", async (req, res) => {
  const { data } = req.body;

  const pythonServiceResponse = await axios.post(
    "http://python-service:4000/sort",
    { data }
  );

  // const sortedData = { sortedData: pythonServiceResponse.data };

  // const reqData = { data, sortedData };

  const goServiceResponse = await axios.post("http://go-service:6000/log", {
    // reqData,
    unSortedData: data,
    sortedData: pythonServiceResponse.data,
  });

  res.json(goServiceResponse.data);
});

app.listen(port, () => {
  console.log(`Listening on port ${port}...`);
});
