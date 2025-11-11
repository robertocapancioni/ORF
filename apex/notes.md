# APEX Integration Notes – Radicle Open Resume 2.0

## Tenant

- Imposta `G_TENANT_ID` in fase di autenticazione.
- Facoltativo: richiama `radicle_ctx_pkg.set_tenant(:G_TENANT_ID)` in un processo "On New Session".

## CRUD su tabelle ORF

- Usa form e IG standard basati sulle tabelle `orf_*`.
- Non gestire manualmente `created`, `updated`, `tenant_id`:
  - sono valorizzati dai trigger.
- Filtra sempre per `tenant_id = :G_TENANT_ID` nelle region (o usa VPD).

## Uso Duality View

- Crea una REST Source su `orf_openresume_v` per esporre il JSON-LD.
- Puoi usare APEX come:
  - frontend di gestione profili,
  - pannello admin multi-tenant,
  - gateway API verso sistemi esterni.

