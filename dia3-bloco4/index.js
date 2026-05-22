const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Endpoint principal (GET /)
app.get('/', (req, res) => {
    res.json({ status: "Trilha Concluída", ambiente: "Particular" });
});

// Endpoint de saúde para o Kubernetes (GET /health)
app.get('/health', (req, res) => {
    res.status(200).json({ status: "UP" });
});

app.listen(PORT, () => {
    console.log(`API rodando com sucesso na porta ${PORT}`);
});