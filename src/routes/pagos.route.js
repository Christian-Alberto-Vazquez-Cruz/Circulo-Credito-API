import { Router } from 'express'
import { PagosController } from '../controller/pagos.controller.js'
const router = Router()

router.get("/:rfc", PagosController.listarPagos)
router.get("/pendientes/:rfc", PagosController.pagosPendientes)
router.get("/estadisticas/:rfc", PagosController.getEstadisticasPagoPorRFC)    

export default router;