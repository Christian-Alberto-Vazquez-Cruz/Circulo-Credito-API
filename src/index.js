import express from 'express'
import validarApiKey from './middleware/validarApiKey.js'
import personasRouter from './routes/personas.route.js'
import obligacionesRouter from  './routes/obligaciones.route.js'
import pagosRouter from './routes/pagos.route.js'
import buroRoute from './routes/buro.route.js'

import { prisma } from './lib/db.js'

const app = express()

app.use(validarApiKey(prisma));

app.get("/consulta", async (req, res) => {
    res.json({
        message: "Acceso concedido",
        usuario: req.apiClient
    });
});

app.use("/personas", personasRouter)
app.use("/obligaciones", obligacionesRouter)
app.use("/pagos", pagosRouter)
app.use("/buro", buroRoute)

app.listen(3000, () => console.log("API en puerto 3000"));