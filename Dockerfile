# ── Etapa 1: compilación con Maven ──────────────────────────────────
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

# Copiar archivos Maven primero para aprovechar caché
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Dar permisos al wrapper Maven
RUN chmod +x mvnw

# Descargar dependencias
RUN ./mvnw dependency:go-offline -q

# Copiar código fuente
COPY src ./src

# Compilar aplicación
RUN ./mvnw clean package -DskipTests -q

# ── Etapa 2: imagen de producción (solo JRE) ─────────────────────────
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Usuario no root
RUN addgroup -S spring && adduser -S spring -G spring

USER spring

# Copiar únicamente el JAR compilado
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]