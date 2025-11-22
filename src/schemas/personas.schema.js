import { z } from "zod";

export const rfcSchema = z.object({
    rfc: z.string()
        .min(12, "RFC debe tener al menos 12 caracteres")
        .max(13, "RFC debe tener máximo 13 caracteres")
        .regex(/^[A-ZÑ&]{3,4}\d{6}[A-Z0-9]{3}$/i, "Formato de RFC inválido")
        .transform(val => val.toUpperCase())
});