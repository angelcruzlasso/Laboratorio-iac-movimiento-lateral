# 0003. Libvirt Provider Version Selection

## Estado

Aceptado

## Contexto

Al inicializar el proyecto, instalamos el proveedor libvirt `dmacvicar/libvirt` con la restricción `>= 0.7.1`. Esto instalaron la versión 0.9.9, que tenía incompatibilidades de API significativas.

Problema encontrado:
- La versión 0.9.x cambió la sintaxis de varios recursos
- `libvirt_volume` usaba `source` en lugar de `base_volume_id`
- `libvirt_domain` requería `network_interface` con bloques anidados en lugar de `network`
- El atributo `base` no era reconocido (debía ser `base_volume_id`)

## Decisión

Fijar la versión del provider a `= 0.7.1` exacta en:
- `terraform/modules/vyos-vm/versions.tf`
- `terraform/environments/lab/main.tf`

Esta versión es estable, bien documentada y compatible con las plantillas de ejemplo del README oficial.

## Consecuencias

### Positivas
- Compatibilidad garantizada con documentación oficial
- Menos sorpresas en tiempo de despliegue
- API estable y probada

### Negativas
- No se obtiene el beneficio de mejoras de versiones posteriores
- Posible problema de seguridad no parcheado

### Neutral
- Para un laboratorio de desarrollo/prueba, la estabilidad es más importante que las últimas características

## Alternativas consideradas

1. **Usar 0.9.9 y actualizar todo el código**: Requiere más tiempo de desarrollo y documentación.
2. **Actualizar a 0.10+**: Aún no es estable en 2026.

## Relación con otras ADRs

- 0001: Formato de registro de decisiones
- 0004: Estrategia de testing (fail-fast)