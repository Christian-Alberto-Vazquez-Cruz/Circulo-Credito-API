import { Router } from 'express'
import { PagosController } from '../controller/pagos.controller.js'
const router = Router()

router.get("/pendientes/:rfc", PagosController.pagosPendientes)
router.get("/estadisticas/:rfc", PagosController.getEstadisticasPagoPorRFC)    
router.get("/:rfc", PagosController.listarPagos)

export default router;