const OpenAI = require("openai");
// สร้างอินสแตนซ์ใหม่ของ OpenAI โดยใช้ API key
/*
const openai = new OpenAI({
  apiKey:
    "k-proj-ztk2YsMUdM7kV4egX19h5WkcfebPO1TIhiOF76eiRrY_SIZTZGg6cxUj-HSzMF8tXFo3C6zySxT3BlbkFJA6v9UcmHdjBJ09ldmP-Gm1WTrN0nDqbWe6WEB8LF3yTd-SpldbMMPkV1FH5esXrZl5xgzL9WYA", // เก็บ API key ไว้ใน environment variable
});

import OpenAI from "openai";
*/
const openai = new OpenAI({
  apiKey:
    "sk-TcfVetO_gFxlYJ3K3kL8DQsucA0qGQMgbtVFHaNwH5T3BlbkFJ9mW1iqE0cos6OQ2-d5kRZcFbWFSrfV-MICzalzX50A",
});

async function getOpenAIResponse() {
  try {
    const response = await openai.chat.completions.create({
      model: "gpt-3.5-turbo", // ใช้โมเดลใหม่ เช่น gpt-3.5-turbo
      messages: [{ role: "user", content: "แนะนำอาหารสำหรับมื้อเย็น" }], // ข้อความที่ต้องการส่งไปยังโมเดล
      max_tokens: 100, // จำนวน token สูงสุด
    });

    console.log(response.choices[0].message.content); // แสดงผลลัพธ์จากโมเดล
  } catch (error) {
    console.error("Error calling OpenAI API:", error);
  }
}

getOpenAIResponse();
