# POO-Doctor

Un ejemplo simple de Programación Orientada a Objetos (POO) en Python que demuestra el uso de clases con el tema de un Doctor.

## Descripción

Este proyecto implementa una clase `Doctor` que representa a un médico con capacidades de saludo. Es un ejemplo educativo de conceptos de POO en Python.

## Características

- Clase `Doctor` con atributos de nombre, especialidad y título
- Soporte para títulos inclusivos (Dr., Dra., etc.)
- Método `saludar()` que retorna un mensaje de bienvenida
- Demostración de constructores con valores por defecto
- Método `__str__` para representación de texto

## Uso

Para ejecutar el programa:

```bash
python3 doctor.py
```

### Salida esperada:

```
Hola, soy Dr. Pérez, especialista en Medicina General
Hola, soy Dra. García, especialista en Pediatría
Hola, soy Dr. Doctor, especialista en General
```

## Ejemplo de Código

```python
# Crear una instancia de Doctor
doctor = Doctor("García", "Cardiología")

# Saludar
print(doctor.saludar())  # Hola, soy Dr. García, especialista en Cardiología

# Crear una doctora con título personalizado
doctora = Doctor("López", "Neurología", "Dra.")
print(doctora.saludar())  # Hola, soy Dra. López, especialista en Neurología
```

## Requisitos

- Python 3.x