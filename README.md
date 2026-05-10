# Programacion Web - Unidad 12

## Post-Contenido 2 - Pipeline CI/CD con GitHub Actions y Docker Hub

## Autor

- Nombre: Kevin Javier Ramirez
- Programa: Ingenieria de Sistemas
- Asignatura: Programacion Web
- Unidad: 12 - Despliegue y CI/CD
- Actividad: Post-Contenido 2
- Proyecto: ramirez-post2-u12

## Objetivo

Diseñar e implementar un pipeline de integración y entrega continua (CI/CD) con GitHub Actions que automatiza compilación, pruebas con cobertura JaCoCo, construcción de imagen Docker multi-stage, y publicación en Docker Hub.

## Tecnologias

- Java 21
- Spring Boot 3.2.5
- Maven Wrapper
- JaCoCo 0.8.10 para reporte de cobertura
- Docker multi-stage build
- GitHub Actions
- Docker Hub

## Pipeline CI/CD

El pipeline se ejecuta automáticamente en cada push a `main` y realiza:

1. **Build-and-test**: Compilación con Maven y ejecución de pruebas unitarias
2. **Publicación de reporte JaCoCo** como artefacto descargable (retenido 7 días)
3. **Docker-publish**: Construcción de imagen Docker con multi-stage build
4. **Publicación en Docker Hub** con tags `latest` y `sha-<commit>`

### GitHub Secrets Requeridos

Los siguientes secrets deben configurarse en Settings → Secrets and variables → Actions:

| Secret | Descripción | Valor |
| --- | --- | --- |
| `DOCKERHUB_USERNAME` | Usuario de Docker Hub | Nombre de usuario |
| `DOCKERHUB_TOKEN` | Access Token de Docker Hub | Token generado en hub.docker.com |

### Flujo del Pipeline

```
┌─────────────────┐
│ Push a main     │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────┐
│ Job 1: build-and-test       │
│  • Maven compile            │
│  • Maven test               │
│  • Generate JaCoCo report   │
│  • Upload artifact (7 days) │
└────────┬────────────────────┘
         │
         ▼(if successful)
┌─────────────────────────────────┐
│ Job 2: docker-publish           │
│  • Login to Docker Hub          │
│  • Build Docker image           │
│  • Push with tags:              │
│    - latest                     │
│    - sha-<commit>               │
└─────────────────────────────────┘
```

## Configuración

### 1. Crear Access Token en Docker Hub

1. Ir a hub.docker.com y iniciar sesión
2. Account → Settings → Security
3. "New Access Token"
4. Seleccionar permisos: Read & Write
5. Copiar el token generado (no se puede recuperar después)

### 2. Agregar Secrets a GitHub

1. Repositorio → Settings → Secrets and variables → Actions
2. Crear `DOCKERHUB_USERNAME` con el usuario de Docker Hub
3. Crear `DOCKERHUB_TOKEN` con el token generado

### 3. Archivo del Workflow

El archivo `.github/workflows/ci.yml` define el pipeline completo.

## Ejecución Manual

Para ejecutar el pipeline, simplemente hacer push a la rama `main`:

```powershell
git add .
git commit -m "feat: implementar pipeline CI/CD"
git push origin main
```

## Verificación

### En GitHub Actions:

1. Ir a Actions → CI/CD — Build, Test & Docker Publish
2. Ver el estado del workflow en ejecución
3. Ambos jobs deben completar con check verde ✓

### En Docker Hub:

1. Ir a hub.docker.com/r/<usuario>/mi-spring-app
2. Verificar que la imagen fue publicada
3. Tags visibles: `latest` y `sha-<commit>`

### Descargar la Imagen

```powershell
docker pull <usuario>/mi-spring-app:latest
docker run -p 8080:8080 -e SPRING_PROFILES_ACTIVE=dev <usuario>/mi-spring-app:latest
```

## Artefactos del Pipeline

- **JaCoCo Report**: Descargable en Actions → workflow → Artifacts (retenido 7 días)
- **Docker Image**: Disponible en Docker Hub (repositorio público)

## Badge de Estado

Agregar al README principal:

```markdown
![CI/CD Status](https://github.com/kevinjavierramirez55-tech/ramirez-post2-u12/actions/workflows/ci.yml/badge.svg)
```

## Repositorio

```text
https://github.com/kevinjavierramirez55-tech/ramirez-post2-u12
```
