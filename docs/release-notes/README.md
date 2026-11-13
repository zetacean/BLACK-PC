# Notas de release / Release notes

Cada release tiene su archivo `docs/release-notes/<etiqueta>.md` (por ejemplo `v1.0.0.md`). El workflow `release.yml` lo usa como cuerpo del release en GitHub; si no existe, publica un texto genérico. Se escribe **antes** de crear la etiqueta (ver [RELEASING.md](../RELEASING.md)).

Each release has its own `docs/release-notes/<tag>.md` (e.g. `v1.0.0.md`). The `release.yml` workflow uses it as the GitHub release body; without it a generic text is published. Write it **before** creating the tag.

## Plantilla / Template

```markdown
## BLACK PC vX.Y.Z

### Español
**Instalar:** descarga `BLACK-PC-Setup.exe`, ejecútalo y elige el `.iso` de tu copia del juego (USA o Europa). El juego no se incluye. `BLACK-PC.zip` es lo mismo sin instalador.

**Novedades**
- …

**Correcciones**
- …

**Cambios internos**
- …

**Limitaciones y lo que no se validó**
- …

### English
**Install:** download `BLACK-PC-Setup.exe`, run it and pick the `.iso` of your own copy (USA or Europe). The game is not included. `BLACK-PC.zip` is the same without an installer.

**New**
- …

**Fixes**
- …

**Internal**
- …

**Known limits and what was not validated**
- …
```

Reglas: describe lo que el jugador nota, no los mensajes de commit; no anuncies nada que no esté en el código; di siempre lo que no se probó.
