import express from 'express'
import validarApiKey from './middleware/validarApiKey.js'
import personasRouter from './routes/personas.route.js'
import {prisma} from './lib/db.js'

const app = express()

app.use(validarApiKey(prisma));

app.get("/consulta", async (req, res) => {
    res.json({
        message: "Acceso concedido",
        usuario: req.apiClient
    });
});

app.use("/personas", personasRouter)

app.listen(3000, () => console.log("API en puerto 3000"));
