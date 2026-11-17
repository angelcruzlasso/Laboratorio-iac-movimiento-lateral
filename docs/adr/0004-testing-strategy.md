# 0004. Testing Strategy (Fail-Fast)

## Estado

En vigor

## Contexto

El laboratorio debe validar que un agente ofensivo puede:
1. Comprometer la DMZ (Juice Shop)
2. Ejecutar movimiento lateral hacia AD (Samba)
3. Escalarse a la BD (MySQL)
4. Todo bajo detección SIEM (Wazuh)

Cualquier error en la infraestructura o en las reglas de firewall invalida la simulación.

## Decisión

Implementar una estrategia de testing por niveles con detención inmediata ante errores:

| Nivel | Herramienta | Momento | Qué valida |
|-------|-------------|---------|------------|
| 1 | terraform fmt -check | Pre-terraform | Formato código |
| 2 | terraform validate | Pre-terraform | Sintaxis valida |
| 3 | terraform plan -out=tfplan | Pre-aplicación | Qué va a crear/modificar/eliminar |
| 4 | Molecule | Post-apply | Funcionalidad roles Ansible |
| 5 | smoke-test.sh | Post-deploy | Sistema "vivo" |

**Regla de oro**: No avanzar al siguiente nivel sin VALIDACIÓN EXITOSA del anterior.

## Detención automática

Scripts y comandos están diseñados para:
- Salir con código 1 si fallan
- Mostrar mensajes claros de error
- No continuar si hay advertencias críticas

## Consecuencias

### Positivas
- Errores detectados temprano
- Infraestructura reproducible
- Documentación automática del estado

### Negativas
- Más tiempo en validación
- Curva de aprendizaje más pronunciada

## Implementación

### Smoke Test (scripts/smoke-test.sh)
```bash
# Verifica:
# - VyOS accesible
# - Juice Shop HTTP 200
# - Contenedores corriendo
# - Puertos no expuestos
# - Firewall reglas cargadas
```

### Reglas de firewall validadas
- DMZ -> Internal: DENY & LOG
- SQL, SMB, LDAP bloqueados

## Relación con AGENTS.md

Este documento complementa las reglas en `AGENTS.md` sobre "Checkpoint: No Avanzar sin Validación".