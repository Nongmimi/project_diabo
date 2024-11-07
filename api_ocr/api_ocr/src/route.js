const express = require("express");
const router = express.Router();

//Middleware
const uploadMiddleware = require("./middlewares/upload.middleware");

//Controller
const indexController = require("./controllers/index_controller");

router.post(
  "/appointment-day",
  uploadMiddleware.uploadImage.single("image"),
  indexController.appointment
);

router.post(
  "/health-certificate",
  uploadMiddleware.uploadImage.single("image"),
  indexController.healthCertificate
);

router.post(
  "/medicine",
  uploadMiddleware.uploadImage.single("image"),
  indexController.medicine
);

router.post(
  "/food",
  uploadMiddleware.uploadImage.single("image"),
  indexController.food
);

module.exports = router;
