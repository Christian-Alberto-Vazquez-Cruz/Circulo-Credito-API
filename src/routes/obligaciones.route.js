import { Router } from 'express'
import { ObligacionesController } from '../controller/obligaciones.controller.js'
const router = Router()

router.get("/:rfc", ObligacionesController.getObligacionesPorRFC)
router.get("/:rfc/detalles", ObligacionesController.getDetallesObligacionesPorRFC)

export default router