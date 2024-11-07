const dayjs = require("dayjs");
const multer = require("multer");
const path = require("path");
const fs = require("fs");

const storageUpload = multer.diskStorage({
  destination: function (req, file, cb) {
    const uploadPath = req.query.path || "publice/uploads/";
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }

    cb(null, uploadPath);
  },
  filename: function (req, file, cb) {
    cb(
      null,
      file.fieldname + "-" + Date.now() + path.extname(file.originalname)
    );
  },
});

const fileFilter = (req, file, cb) => {
  const allowedTypes = /jpeg|jpg|png/;
  const mimeType = allowedTypes.test(file.mimetype);
  const extName = allowedTypes.test(
    path.extname(file.originalname).toLowerCase()
  );

  //if (mimeType && extName) {
  return cb(null, true);
  //} else {
  //cb("Error: Images Only!");
  //}
};

const uploadImage = multer({ storage: storageUpload, fileFilter: fileFilter });

module.exports = {
  uploadImage,
};
