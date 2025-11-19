
export default function validarApiKey(prisma) {

    return async function (req, res, next) {
        const apiKey = req.headers["x-api-key"];

        if (!apiKey) {
            return res.status(401).json({
                error: "Incluya el header 'x-api-key'"
            });
        }

        try {
            const apiClient = await prisma.api_clients.findFirst({
                where: {
                    api_key: apiKey,
                    estatus: "ACTIVO"
                }
            });

            if (!apiClient) {
                return res.status(401).json({
                    error: "API Key inválida o inactiva"
                });
            }

            req.apiClient = apiClient;

            return next();

        } catch (error) {
            console.error("Error validando API Key:", error);
            return res.status(500).json({
                error: "Error interno en validación de API Key"
            });
        }
    };
};
