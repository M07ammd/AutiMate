import express from "express";
import axios from "axios";
import dotenv from "dotenv";
import cors from "cors";


dotenv.config();
const app = express();
app.use(express.json());

app.use(cors({
  origin: "http://localhost:5173"
}));


app.post("/chat", async (req, res) => {
  const { message } = req.body;

  const systemPrompt = "You are a friendly and patient assistant for people with autism. Use simple, encouraging language.";

  try {
    const response = await axios.post(
      "https://api.groq.com/openai/v1/chat/completions",
      {
        model: "llama-3.1-8b-instant",
        messages: [
          { role: "system", content: systemPrompt },
          { role: "user", content: message }
        ]
      },
      {
        headers: {
          "Authorization": `Bearer ${process.env.GROQ_API_KEY}`,
          "Content-Type": "application/json"
        }
      }
    );

    const reply = response.data.choices[0].message.content;
    res.json({ reply });

  } catch (err) {
    console.error(err.response?.data || err.message);
    res.status(500).json({ error: "Something went wrong" });
  }
});

app.listen(5000, () => {
  console.log("Server running on http://localhost:5000");
});
