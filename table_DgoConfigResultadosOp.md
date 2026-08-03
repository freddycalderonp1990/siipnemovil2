# Ayuda Memoria - Configuración de Resultados de Operativos

## Tabla

**DgoConfigResultadosOp**

## Relación

* Se relaciona con **DgoConfigOperativos** mediante `idConfigOperativo`.
* Cada módulo tendrá su propia configuración de resultados.

## Campo `configuracion` (JSON)

Almacena la estructura de los operativos y las variables que se mostrarán en el módulo.

### Estructura

* **idOperativo**: ID del operativo existente en la base de datos.
* **idPadre**: ID del operativo padre.

    * `null` → Operativo principal (Ej.: Ordinario, Extraordinario).
    * Valor → Operativo hijo del padre indicado.
* **variables**: Arreglo con los IDs de las variables que podrá registrar el operativo.

## Ejemplo

```json

{
  "operativos": [
    {
      "idOperativo": 10,
      "idPadre": null,
      "variables": []
    },
    {
      "idOperativo": 2,
      "idPadre": 10,
      "variables": [1, 2, 3]
    },
    {
      "idOperativo": 3,
      "idPadre": 1,
      "variables": [4, 5]
    }
  ]
}

1 operativo polco

2 - 1

config


{
  "operativos": [
    {
      "idOperativo": 21330,
      "name": "op.su-extraordinarios-institucional-INSTITUCIONAL",
      "variables": []
    },
    {
      "idOperativo": 21329,
      "name": "op.su-extraordinarios-ESTADO DE EXCEPCIÓN",
      "variables": [1, 2, 3]
    },
    {
      "idOperativo": 21323,
      "name": "ANTIDELINCUENCIAL",
      "variables": [4, 5]
    },
    {
      "idOperativo": 21277,
      "name": "PERSONAS",
      "variables": [4, 5]
    }
  ]
}

```

## Flujo de funcionamiento

1. Obtener el módulo desde **DgoConfigOperativos**.
2. Leer el campo **configuracion** de **DgoConfigResultadosOp**.
3. Mostrar los operativos con `idPadre = null`.
4. Al seleccionar un operativo principal, mostrar todos los operativos cuyo `idPadre` sea igual al `idOperativo` seleccionado.
5. Al seleccionar un operativo hijo, consultar las variables utilizando los IDs almacenados en `variables`.
6. Generar el formulario dinámicamente.

## Consideraciones

* El JSON **no almacena nombres**, únicamente **IDs**.
* Los nombres de operativos y variables siempre se obtienen desde las tablas existentes.
* El JSON únicamente define:

    * La jerarquía de operativos (padre → hijo).
    * Las variables que corresponden a cada operativo.

## Dependencias del sistema

La configuración utiliza información existente del sistema. Antes de configurar un nuevo módulo, verificar lo siguiente:

### Crear un nuevo operativo

Si se requiere un nuevo operativo (tipificación), primero debe ser creado desde:

**Aplicación:** Operaciones → Administración → Clase Tipificación

**Tabla:** `genTipoTipificacion`

Una vez creado, su `idOperativo` podrá utilizarse dentro del JSON de configuración.

### Crear una nueva variable

Si se requiere una nueva variable para el resumen del operativo, primero debe ser creada desde:

**Aplicación:** Operaciones → Administración → Tipo Resumen

**Tabla:** `hdrTipoResumen`

Una vez creada, su ID podrá agregarse en el arreglo `variables` del JSON.

## Beneficios

* No modifica las tablas existentes.
* Cada módulo posee su propia configuración.
* Permite agregar o quitar operativos y variables sin modificar el código.
* El formulario se genera dinámicamente a partir de la configuración almacenada.
* Reutiliza la información existente del sistema, evitando duplicidad de datos.
