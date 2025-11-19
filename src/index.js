import express from 'express'
import { PrismaClient } from "../generated/prisma/index.js"
import validarApiKey from './middleware/validarApiKey.js'

const prisma = new PrismaClient()
const app = express()

app.use(validarApiKey(prisma));

app.get("/consulta", async (req, res) => {
    res.json({
        message: "Acceso concedido",
        usuario: req.apiClient
    });
});


app.listen(3000, () => console.log("API en puerto 3000"));
