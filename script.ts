import { PrismaClient } from "./generated/prisma/client.js";

const prisma = new PrismaClient();

async function testConnection() {
  try {
    console.log("🔄 Probando conexión con la base de datos...\n");
    
    // Prueba de conexión básica
    await prisma.$connect();
    console.log("✅ Conexión exitosa con la base de datos\n");
    
    // Obtener todas las personas
    console.log("📋 Obteniendo personas...\n");
    const personas = await prisma.personas.findMany({
      take: 10, // Limitar a 10 registros para la prueba
      orderBy: {
        created_at: 'desc'
      }
    });
    
    console.log(`📊 Total de personas encontradas: ${personas.length}\n`);
    
    if (personas.length > 0) {
      console.log("👥 Primeras personas:");
      personas.forEach((persona, index) => {
        console.log(`\n${index + 1}. RFC: ${persona.rfc}`);
        console.log(`   Tipo: ${persona.tipo_persona}`);
        console.log(`   Email: ${persona.email || 'N/A'}`);
        console.log(`   Teléfono: ${persona.telefono || 'N/A'}`);
        console.log(`   Estatus: ${persona.estatus}`);
      });
    } else {
      console.log("⚠️  No se encontraron personas en la base de datos");
    }
    
    // Estadísticas adicionales
    console.log("\n📈 Estadísticas:");
    const totalPersonas = await prisma.personas.count();
    const personasFisicas = await prisma.personas.count({
      where: { tipo_persona: 'FISICA' }
    });
    const personasMorales = await prisma.personas.count({
      where: { tipo_persona: 'MORAL' }
    });
    const personasActivas = await prisma.personas.count({
      where: { estatus: 'ACTIVO' }
    });
    
    console.log(`   Total de personas: ${totalPersonas}`);
    console.log(`   Personas físicas: ${personasFisicas}`);
    console.log(`   Personas morales: ${personasMorales}`);
    console.log(`   Personas activas: ${personasActivas}`);
    
  } catch (error) {
    console.error("❌ Error al conectar con la base de datos:");
    console.error(error);
  } finally {
    await prisma.$disconnect();
    console.log("\n🔌 Conexión cerrada");
  }
}

// Ejecutar el script
testConnection();