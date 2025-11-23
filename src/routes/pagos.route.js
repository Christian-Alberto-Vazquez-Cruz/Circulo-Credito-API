import { Router } from 'express'
import { PagosController } from '../controller/pagos.controller.js'
const router = Router()

router.get("/:rfc", PagosController.listarPagos)
router.get("/pendientes/:rfc", PagosController.pagosPendientes)
    
export default router;