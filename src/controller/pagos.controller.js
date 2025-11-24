import { rfcSchema } from '../schemas/personas.schema.js';
import { prisma } from "../lib/db.js";
import { responderConError, responderConExito } from '../utilities/manejadores.js';
import {
    ENTRADA_INVALIDA, 
    ESTADISTICAS_ENCONTRADAS_PAGO, 
    MENSAJE_ERROR_GENERICO, 
    PAGOS_ENCONTRADOS, 
    PERSONA_NO_ENCONTRADA_RFC,
    RESUMEN_ENCONTRADO
} from "../utilities/constantes.js";

export class PagosController {
    static async listarPagos(req, res) {
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

            const pagos = await prisma.vw_historial_pagos.findMany({
                where: { rfc },
                orderBy: { fecha_programada: "desc" }
            });

            return responderConExito(
                res, 200, 
                PAGOS_ENCONTRADOS(pagos.length), pagos
            );

        } catch (err) {
            console.error("Error en listarPagos:", err);
            return responderConError(res, 500, MENSAJE_ERROR_GENERICO);
        }
    }

    static async pagosPendientes(req, res) {
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

            const pagosPendientes = await prisma.vw_pagos_pendientes.findMany({
                where: { 
                    rfc,
                    estatus_pago: "PENDIENTE"
                },
                orderBy: { fecha_programada: "asc" } 
            });

            return responderConExito(
                res,
                200,
                PAGOS_ENCONTRADOS(pagosPendientes.length),
                pagosPendientes
            );

        } catch (err) {
            console.error("Error en pagosPendientes:", err);
            return responderConError(res, 500, MENSAJE_ERROR_GENERICO);
        }
    }

    static async getEstadisticasPagoPorRFC(){
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

            const resumenCrediticio = await prisma.vw_resumen_crediticio.findFirst({
                where: { rfc }
            });

            return responderConExito(res,200,
                ESTADISTICAS_ENCONTRADAS_PAGO(rfc), resumenCrediticio
            );

        } catch (err) {
            console.error("Error en getEstadisticasPorRFC:", err);
            return responderConError(res, 500, MENSAJE_ERROR_GENERICO);
        }
    }
}