import { Router } from 'express'
import { PersonaController } from '../controller/personas.controller.js'

const router = Router()

router.get("/rfc/:rfc", PersonaController.getPersonaPorRFC)

export default router;