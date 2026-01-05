import { Router } from 'express'
import { BuroController } from '../controller/buro.controller.js'
const router = Router()

router.get("/resumen/:rfc", BuroController.getResumenCrediticioPorRFC)

export default router