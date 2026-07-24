# 📌 Changelog



### Configuración de módulos de SIIPNE Móvil - 23 de julio de 2026

Con el fin de evitar mantener relaciones mediante identificadores (IDs) definidos directamente en el código fuente, se deberá crear una tabla de 
configuración denominada dgoConfigOperativos. Esta tabla permitirá asociar cada módulo registrado en genModulo con el Tipo de Operativo correspondiente 
de la tabla GenTipoTipificacion y con el Tipo de Servicio de la tabla hdrTipoServicio.

De esta manera, cuando el usuario seleccione un módulo en la aplicación, el sistema obtendrá automáticamente la configuración desde la base de datos, 
sin necesidad de realizar modificaciones en el código cuando se creen nuevos módulos o se requiera cambiar la configuración existente.

Ejemplo:

Módulo (genModulo): Móviles Operativos Preventivos.
Tipo de Operativo (GenTipoTipificacion): OPERATIVO SERVICIO URBANO.
Tipo de Servicio (hdrTipoServicio): Móviles TR.

Con esta configuración, al seleccionar el módulo "Móviles Operativos Preventivos", el sistema registrará automáticamente el Tipo de Operativo como 
"OPERATIVO SERVICIO URBANO" y el Tipo de Servicio como "Móviles TR", de acuerdo con la relación definida en la tabla dgoConfigOperativos.

La tabla dgoConfigOperativos complementará la configuración existente en dgoConfigOperativos, la cual es utilizada por el SIIPNE 3W para determinar los 
operativos habilitados para cada módulo. Mientras dgoConfigOperativos controla la disponibilidad del operativo, dgoConfigOperativos definirá la 
información adicional requerida por SIIPNE Móvil para registrar automáticamente el Tipo de Operativo y el Tipo de Servicio asociados al módulo seleccionado.

### Consideraciones importantes

Para que un módulo se visualice y funcione correctamente en SIIPNE Móvil, deberán cumplirse las siguientes condiciones:

El módulo debe existir en la tabla genModulo.
La aplicación debe estar registrada en GenAplicacion.
El módulo debe encontrarse configurado y habilitado en la tabla dgoConfigOperativos.
Debe existir al menos un registro del Tipo de Operativo en la tabla GenTipoTipificacion.
Debe existir el Tipo de Servicio correspondiente en la tabla hdrTipoServicio.
El usuario debe tener asignados los permisos sobre el módulo y la aplicación en SIIPNE 3W.
Debe existir un registro activo en la tabla dgoConfigOperativos, que relacione el módulo con el Tipo de Operativo y el Tipo de Servicio que utilizará la 
aplicación móvil.

En consecuencia, SIIPNE Móvil únicamente mostrará los módulos que cumplan con toda la configuración descrita anteriormente. Si falta cualquiera de estos 
elementos, especialmente la configuración en dgoConfigOperativos o la relación en dgoConfigOperativos, el módulo no será visible en la aplicación, aunque 
exista en genModulo y el usuario tenga los permisos correspondientes en SIIPNE 3W.

De esta forma, la incorporación de nuevos módulos y operativos se realizará mediante configuración en la base de datos, evitando modificaciones en el 
código fuente y facilitando el mantenimiento y escalabilidad de la aplicación.
