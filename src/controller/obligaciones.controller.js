import { rfcSchema } from '../schemas/personas.schema.js';
import { prisma } from "../lib/db.js";
import {ENTRADA_INVALIDA, MENSAJE_ERROR_GENERICO, 
    PERSONA_NO_ENCONTRADA_RFC, OBLIGACIONES_ENCONTRADAS } from "../utilities/constantes.js";
import { responderConExito, responderConError } from "../utilities/manejadores.js";

export class ObligacionesController {

    static async getObligacionesPorRFC(req, res) {
        try {
            const validacion = rfcSchema.safeParse(req.params);

            if (!validacion.success){
                return responderConError(res, 400, ENTRADA_INVALIDA)
            }

            const {rfc} = validacion.data

            const persona = await prisma.personas.findUnique({
                where: { rfc }
            });

            if (!persona) {
                return responderConError(res, 404, PERSONA_NO_ENCONTRADA_RFC);
            }

            const obligaciones = await prisma.obligaciones_crediticias.findMany({
                where: {persona_id: persona.id},
                orderBy: {fecha_apertura: "desc"}
            })

            return responderConExito(res, 200, 
                OBLIGACIONES_ENCONTRADAS(obligaciones.length),
                obligaciones
            );        
        } catch (error){
            console.error("Error en getDetallesObligacionesPorRFC:", error);
            return responderConError(res, 500, MENSAJE_ERROR_GENERICO);
        }
    }

    static async getDetallesObligacionesPorRFC(req, res) {
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

            const detalles = await prisma.vw_detalle_obligaciones.findMany({
                where: { rfc },
                orderBy: { fecha_apertura: "desc" }
            });

            return responderConExito(
                res, 200, OBLIGACIONES_ENCONTRADAS(detalles.length),
                detalles
            );

        } catch (error) {
            console.error("Error en getDetallesObligacionesPorRFC:", error);
            return responderConError(res, 500, MENSAJE_ERROR_GENERICO);
        }
    }
}
