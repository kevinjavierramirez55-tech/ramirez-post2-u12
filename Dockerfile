# -- Etapa 1: compilacion con Maven ------------------------------------------
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app

# Copiar pom.xml primero para aprovechar la cache de capas de Docker.
# Si las dependencias no cambian, Maven no las descarga en builds siguientes.
COPY pom.xml .

COPY mvnw ./
COPY .mvn .mvn
RUN ./mvnw dependency:go-offline -q

COPY src ./src
RUN ./mvnw clean package -DskipTests -q

# -- Etapa 2: imagen de produccion (solo JRE) ---------------------------------
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Usuario no root: buena práctica de seguridad en contenedores
RUN addgroup -S spring && adduser -S spring -G spring && mkdir -p /app/logs && chown -R spring:spring /app
USER spring

# Copiar unicamente el JAR compilado desde la etapa de builder
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
