# Radicle Open Resume 2.0 – Spec Overview

Radicle Open Resume 2.0 (ORF) è uno standard aperto per rappresentare CV e profili professionali:

- Basato su Oracle Database 23ai.
- Esportabile in JSON-LD compatibile con standard moderni (schema.org, Europass/ELM).
- Multi-tenant nativo.
- Estendibile a Verifiable Credentials.

## Componenti principali

- Modello relazionale `orf_*`
- Trigger standard per:
  - `tenant_id`
  - metadati `created`, `created_by`, `updated`, `updated_by`
- JSON Relational Duality View `orf_openresume_v`
- API REST per esposizione e integrazione
- Esempio JSON-LD di riferimento

Per i dettagli tecnici vedi:

- `docs/data-model.md`
- `docs/jsonld-spec.md`
- `docs/integration-guide.md`
