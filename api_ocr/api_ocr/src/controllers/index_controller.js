const { Op } = require("@sequelize/core");
const dayjs = require("dayjs");
const sha1 = require("sha1");
const { GoogleGenerativeAI } = require("@google/generative-ai");
const fs = require("fs");
const { dirname } = require("path");
const { fileURLToPath } = require("url");

require("dotenv").config();

/**
 * @swagger
 * /api/appointment-day:
 *   post:
 *     tags:
 *           - OCR
 *     summary: วันนัด
 *     description: วันนัด
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               image:
 *                 type: string
 *                 format: binary
 *     responses:
 *      201:
 *        description: OK
 */
//วันนัด
async function appointment(req, res, next) {
  try {
    let filePath = req.file.path;
    let fileName = req.file.filename;
    if (process.env.MODE_RUN === "prod") {
      const genAI = new GoogleGenerativeAI(process.env.GOOGLE_GEMINI_KEY);
      const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
      const prompt = "ocr return json";
      const imagePart = fileToGenerativePart(req.file.path, "image/jpeg");
      const result = await model.generateContent([prompt, imagePart]);
      let txt = result.response.text();
      let dataJson = txt.replace("```json", "");
      dataJson = dataJson.replace("```", "");
      dataJson = JSON.parse(dataJson);
      return res.status(200).json(dataJson);
    } else {
      return res.status(200).json({
        hospital: "test",
        date: "2024-11-10 08:00",
        appointmentDate: "124",
      });
    }
  } catch (error) {
    next(error);
  }
}

/**
 * @swagger
 * /api/health-certificate:
 *   post:
 *     tags:
 *           - OCR
 *     summary: ตรวจสุขภาพ
 *     description: ตรวจสุขภาพ
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               image:
 *                 type: string
 *                 format: binary
 *     responses:
 *      201:
 *        description: OK
 */
//ผลตรวจสุขภาพ
async function healthCertificate(req, res, next) {
  try {
    let filePath = req.file.path;
    let fileName = req.file.filename;
    if (process.env.MODE_RUN === "prod") {
      const genAI = new GoogleGenerativeAI(process.env.GOOGLE_GEMINI_KEY);
      const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
      const prompt = "ocr return json";
      const imagePart = fileToGenerativePart(req.file.path, "image/jpeg");
      const result = await model.generateContent([prompt, imagePart]);
      let txt = result.response.text();
      let dataJson = txt.replace("```json", "");
      dataJson = dataJson.replace("```", "");
      dataJson = JSON.parse(dataJson);
      return res.status(200).json(dataJson);
    } else {
      return res.status(200).json({
        ldl: Math.floor(Math.random() * 9),
        sugar: Math.floor(Math.random() * 9),
      });
    }
  } catch (error) {
    next(error);
  }
}

/**
 * @swagger
 * /api/medicine:
 *   post:
 *     tags:
 *           - OCR
 *     summary: ยา
 *     description: ยา
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               image:
 *                 type: string
 *                 format: binary
 *     responses:
 *      201:
 *        description: OK
 */
//เวลากินยา
async function medicine(req, res, next) {
  try {
    let filePath = req.file.path;
    let fileName = req.file.filename;
    if (process.env.MODE_RUN === "prod") {
      const genAI = new GoogleGenerativeAI(process.env.GOOGLE_GEMINI_KEY);
      const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
      const prompt = "ocr return json";
      const imagePart = fileToGenerativePart(req.file.path, "image/jpeg");
      const result = await model.generateContent([prompt, imagePart]);
      let txt = result.response.text();
      console.log("txt", txt);
      let dataJson = txt.replace("```json", "");
      dataJson = dataJson.replace("```", "");
      dataJson = JSON.parse(dataJson);
      return res.status(201).json(dataJson);
    } else {
      return res.status(200).json({ time: "08:00" });
    }
  } catch (error) {
    next(error);
  }
}

/**
 * @swagger
 * /api/food:
 *   post:
 *     tags:
 *           - OCR
 *     summary: อาหาร
 *     description: อาหาร
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               image:
 *                 type: string
 *                 format: binary
 *     responses:
 *      201:
 *        description: OK
 */
//เวลากินยา
async function food(req, res, next) {
  try {
    let filePath = req.file.path;
    let fileName = req.file.filename;
    if (process.env.MODE_RUN === "prod") {
      const genAI = new GoogleGenerativeAI(process.env.GOOGLE_GEMINI_KEY);
      const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

      const promptFood = "รูปคืออะไรแค่เอาชื่ออย่างเดียว";
      const imagePart = fileToGenerativePart(req.file.path, "image/jpeg");
      const resultFood = await model.generateContent([promptFood, imagePart]);
      let foodName = resultFood.response.text();
      console.log("foodName", foodName);
      const promptCarbs =
        foodName + "มีปริมาณคาร์โบไฮเดรต ต้องการค่าเป็นตัวเลขอย่างเดียว";
      const resultCarbs = await model.generateContent([promptCarbs]);
      let carbVal = 0;
      const carbs = resultCarbs.response.text();
      const carbsEx = carbs.split("-");
      if (carbsEx.length == 2) {
        carbVal = carbsEx[1];
      } else {
        carbVal = carbs;
      }
      console.log("carbs", carbs);
      //let dataJson = txt.replace("```json", "");
      //dataJson = dataJson.replace("```", "");
      //dataJson = JSON.parse(dataJson);
      return res.status(200).json([
        {
          foodName: foodName.replace(/\s+/g, "").replace(/\n/g, ""),
          carb: carbVal
            .replace(/\s+/g, "")
            .replace(/\n/g, "")
            .replace(/กรัม/g, ""),
        },
      ]);
    } else {
      return res.status(200).json({
        foodName: "ข้าวมันไก่",
        carb: 3.0,
      });
    }
  } catch (error) {
    next(error);
  }
}

function fileToGenerativePart(path, mimeType) {
  return {
    inlineData: {
      data: Buffer.from(fs.readFileSync(path)).toString("base64"),
      mimeType,
    },
  };
}

module.exports = {
  appointment,
  healthCertificate,
  medicine,
  food,
};
