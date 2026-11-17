# 0001. Record Architecture Decisions

## Status

Aceptado

## Contexto

Necesitamos documentar las decisiones arquitectónicas clave del laboratorio de movimiento lateral para que otros desarrolladores y el propio agente de IA puedan entender el porqué de las decisiones técnicas.

## Decisión

Usar el formato ADR (Architecture Decision Records) de Michael Nygard. Cada decisión significativa se documenta en un archivo markdown con:

- Estado (Propuesto, Aceptado, Rechazado, En Vigor, Supeditado)
- Contexto (qué problema resuelve)
- Decisión (qué elegimos)
- Consecuencias (impacto positivo/negativo)

## Consecuencias

### Positivas
- Historial claro de decisiones
- Facilita onboarding de nuevos miembros
- Reference para el agente de IA
- Cumple con mejores prácticas de documentación

### Negativas
- Overhead de mantenimiento
- Necesidad de recordar actualizar ADRs

## Decisiones documentadas

| Nº | Tema | Estado |
|----|------|--------|
| 0001 | Formato de registro de decisiones | Aceptado |
| 0002 | Separación Terraform/Ansible | En vigor |
| 0003 | Proveedor libvirt versión | Aceptado |
| 0004 | Estrategia de testing | En vigor |