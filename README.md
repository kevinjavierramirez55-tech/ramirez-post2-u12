# Programacion Web - Unidad 11

## Post-Contenido 1 - Refactorizacion con SOLID, DAO/DTO y ControllerAdvice

## Autor

- Nombre: Kevin Javier Ramirez
- Programa: Ingenieria de Sistemas
- Asignatura: Programacion Web
- Unidad: 11 - Buenas Practicas y Patrones de Diseno
- Actividad: Post-Contenido 1
- Fecha: 09/05/2026

## Objetivo

Este proyecto refactoriza una API REST de catalogo de productos aplicando buenas
practicas de arquitectura en capas. La solucion separa responsabilidades con
SOLID, usa Repository como DAO, DTOs para entrada y salida, un Factory para
convertir objetos y un `@RestControllerAdvice` para centralizar errores.

## Tecnologias

- Java 17
- Spring Boot 3.2.5
- Maven
- Spring Web
- Spring Data JPA
- H2 Database
- Bean Validation

## Arquitectura implementada

```text
src/main/java/com/empresa/catalogo/
|-- controller/
|   `-- ProductoController.java
|-- service/
|   |-- ProductoService.java
|   `-- ProductoServiceImpl.java
|-- repository/
|   `-- ProductoRepository.java
|-- dto/
|   |-- ProductoRequestDTO.java
|   `-- ProductoResponseDTO.java
|-- entity/
|   `-- Producto.java
|-- factory/
|   `-- ProductoFactory.java
`-- exception/
    |-- ApiError.java
    |-- GlobalExceptionHandler.java
    `-- RecursoNoEncontradoException.java
```

```text
Cliente HTTP
    |
    v
ProductoController
    |
    v
ProductoService (interfaz - DIP)
    |
    v
ProductoServiceImpl
    |                 \
    v                  v
ProductoRepository   ProductoFactory
    |                  |
    v                  v
Producto Entity      ProductoRequestDTO / ProductoResponseDTO

GlobalExceptionHandler captura excepciones y responde con ApiError.
```

## Buenas practicas aplicadas

- SRP: cada clase tiene una responsabilidad concreta.
- DIP: el controlador depende de `ProductoService`, no de la implementacion.
- DAO: `ProductoRepository` extiende `JpaRepository`.
- DTO: `ProductoRequestDTO` valida entrada y `ProductoResponseDTO` controla la salida.
- Factory: `ProductoFactory` centraliza la conversion entre entidad y DTO.
- Manejo global: `GlobalExceptionHandler` responde 404, 400 y 500 con `ApiError`.

## Ejecucion

Desde PowerShell, en la raiz del proyecto:

```powershell
cd "C:\Users\KEVIN\Downloads\programaciónWeb\catalogo"
.\mvnw.cmd compile
.\mvnw.cmd spring-boot:run
```

La API queda disponible en:

```text
http://localhost:8080/api/productos
```

## Endpoints

| Metodo | Ruta | Descripcion |
| --- | --- | --- |
| GET | `/api/productos` | Lista productos activos |
| GET | `/api/productos/{id}` | Busca un producto por id |
| POST | `/api/productos` | Crea un producto |
| DELETE | `/api/productos/{id}` | Elimina un producto por id |

## Pruebas con curl

### Listar productos

```powershell
curl.exe -i http://localhost:8080/api/productos
```

Respuesta esperada inicial:

```json
[]
```

### Crear producto

```powershell
curl.exe -i -X POST http://localhost:8080/api/productos `
  -H "Content-Type: application/json" `
  -d "{\"nombre\":\"Laptop\",\"precio\":3500000,\"categoria\":\"ELECTRONICA\"}"
```

Respuesta esperada:

```json
{
  "id": 1,
  "nombre": "Laptop",
  "precio": 3500000.0,
  "categoria": "ELECTRONICA"
}
```

### Producto inexistente

```powershell
curl.exe -i http://localhost:8080/api/productos/999
```

Respuesta esperada:

```json
{
  "status": 404,
  "error": "Not Found",
  "mensaje": "Producto con id 999 no encontrado.",
  "timestamp": "...",
  "path": "/api/productos/999"
}
```

### Validacion de entrada

```powershell
curl.exe -i -X POST http://localhost:8080/api/productos `
  -H "Content-Type: application/json" `
  -d "{}"
```

Respuesta esperada:

```json
{
  "status": 400,
  "error": "Bad Request",
  "mensaje": "nombre: El nombre es obligatorio; precio: El precio es obligatorio",
  "timestamp": "...",
  "path": "/api/productos"
}
```

## Checkpoints y evidencias

### Checkpoint 1

Comprobar que el proyecto compila:

```powershell
.\mvnw.cmd compile
```

Tomar captura cuando aparezca `BUILD SUCCESS`.

Evidencia sugerida:

```text
evidencias/checkpoint-1-compile.png
```

### Checkpoint 2

Ejecutar la aplicacion:

```powershell
.\mvnw.cmd spring-boot:run
```

En otra terminal probar:

```powershell
curl.exe -i http://localhost:8080/api/productos
curl.exe -i -X POST http://localhost:8080/api/productos -H "Content-Type: application/json" -d "{\"nombre\":\"Laptop\",\"precio\":3500000,\"categoria\":\"ELECTRONICA\"}"
```

Tomar captura del `GET` con lista vacia y del `POST` con estado `201 Created` y
DTO de respuesta con `id`.

Evidencia sugerida:

```text
evidencias/checkpoint-2-post-producto.png
```

### Checkpoint 3

Con la aplicacion encendida, probar:

```powershell
curl.exe -i http://localhost:8080/api/productos/999
curl.exe -i -X POST http://localhost:8080/api/productos -H "Content-Type: application/json" -d "{}"
```

Tomar captura del 404 y del 400 con cuerpo JSON `ApiError`.

Evidencias sugeridas:

```text
evidencias/checkpoint-3-error-404.png
evidencias/checkpoint-3-error-400.png
```
