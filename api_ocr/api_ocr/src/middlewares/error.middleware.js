const path = require("path");
const fs = require("fs");

const errorHandler = (err, req, res, next) => {
  //console.error(err.stack);
  console.error(err);

  const logDirectory = path.join(__dirname, "./../../logs");

  // ตรวจสอบว่ามีไดเรกทอรี logs หรือไม่ ถ้าไม่มีให้สร้างใหม่
  if (!fs.existsSync(logDirectory)) {
    fs.mkdirSync(logDirectory);
  }

  const logFile = path.join(
    logDirectory,
    `${new Date().toISOString().split("T")[0]}.log`
  );
  const logMessage = `${new Date().toISOString()} - ${err.stack}\n`;

  // เขียน log ลงไฟล์แยกตามวัน
  fs.appendFileSync(logFile, logMessage, "utf8");

  res.status(err.status || 500);
  res.json({
    message: err.message,
    stack: process.env.NODE_ENV === "production" ? {} : err.stack,
  });
};

module.exports = errorHandler;
