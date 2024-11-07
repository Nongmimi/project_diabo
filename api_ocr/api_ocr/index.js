const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const swaggerJSDoc = require("swagger-jsdoc");
const dotenv = require("dotenv").config();
const swaggerUi = require("swagger-ui-express");
const swaggerDefinition = require("./swagger/swagger");
const apiRoute = require("./src/route");
const errorHandler = require("./src/middlewares/error.middleware");

const app = express();

const corsOptions = {
  origin: [
    "http://localhost:5173",
    "http://192.168.1.38:5173",
    "http://localhost:3000",
    "http://localhost:3002",
    "https://ecom.amphol.xyz",
  ],
  credentials: true,
};

app.use(cors(corsOptions));
app.use(bodyParser.json({ limit: "50mb" }));
app.use(bodyParser.urlencoded({ limit: "50mb", extended: true }));

app.use("/publice", express.static(__dirname + "/publice"));

//swagger
const options = {
  definition: swaggerDefinition,
  apis: [".//*.js", "./src/controllers/*.js"],
};

const swaggerSpec = swaggerJSDoc(options);
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app.get("/", (req, res) => {
  res.send("Start");
});

app.use("/api", apiRoute);
app.use((req, res, next) => {
  res.status(404).json({ message: "Not Found" });
});
app.use(errorHandler);

app.listen(process.env.APP_PORT, () =>
  console.log(`Start API listening on port ${process.env.APP_PORT}!`)
);
