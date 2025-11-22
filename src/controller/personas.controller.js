import { rfcSchema } from '../schemas/personas.schema.js';
import { ENTRADA_INVALIDA, MENSAJE_ERROR_GENERICO, PERSONA_ENCONTRADA, PERSONA_NO_ENCONTRADA_RFC } from '../utilities/constantes.js';
import { responderConExito, responderConError } from '../utilities/manejadores.js';
import {prisma} from '../lib/db.js'

export class PersonaController {
    
    
    static async getPersonaPorRFC(req, res) {
        try {
            const validacion = rfcSchema.safeParse(req.params);

            if (!validacion.success) {
                return responderConError(res, 400, ENTRADA_INVALIDA);
            }

            const { rfc } = validacion.data;

            const persona = await prisma.vw_persona_completa.findFirst({
                where: { rfc }
            });

            if (!persona) {
                return responderConError(res, 404, PERSONA_NO_ENCONTRADA_RFC);
            }

            return responderConExito(res, 200, PERSONA_ENCONTRADA, persona);

        } catch (error) {
            console.error("Error en getPersonaPorRFC:", error);
            return responderConError(res, 500, MENSAJE_ERROR_GENERICO);
        }
    }
}