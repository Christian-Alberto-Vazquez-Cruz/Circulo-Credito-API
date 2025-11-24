import { rfcSchema } from '../schemas/personas.schema.js';
import { prisma } from "../lib/db.js";
import {ENTRADA_INVALIDA, MENSAJE_ERROR_GENERICO, 
    PERSONA_NO_ENCONTRADA_RFC, OBLIGACIONES_ENCONTRADAS, 
    RESUMEN_ENCONTRADO} from "../utilities/constantes.js";
import { responderConExito, responderConError } from "../utilities/manejadores.js";

export class BuroController {
    static async getResumenCrediticioPorRFC(req, res){
        try {
            const validacion = rfcSchema.safeParse(req.params);

            if (!validacion.success) {
                return responderConError(res, 400, ENTRADA_INVALIDA);
            }

            const { rfc } = validacion.data;

            const persona = await prisma.personas.findUnique({
                where: { rfc }
            });

            if (!persona) {
                return responderConError(res, 404, PERSONA_NO_ENCONTRADA_RFC);
            }

            const detalles = await prisma.vw_resumen_crediticio.findFirst({
                where: { rfc }
            });

            return responderConExito(
                res, 200, RESUMEN_ENCONTRADO(rfc), detalles
            );

        } catch (error) {
            console.error("Error en getResumenCrediticioPorRFC:", error);
            return responderConError(res, 500, MENSAJE_ERROR_GENERICO);
        }
    }
}