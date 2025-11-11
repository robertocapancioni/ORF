# Radicle Open Resume 2.0 (ORF)

Radicle Open Resume 2.0 è uno **standard aperto** per la gestione di CV e profili professionali, progettato per:

- sistemi HR e ATS,
- portali di candidatura,
- piattaforme di formazione e certificazione,
- integrazioni B2B in ambito enterprise.

Si basa su:

- **modello relazionale Oracle** (ottimizzato per Oracle Database 23ai),
- **JSON-LD** per interoperabilità semantica,
- supporto **multitenant nativo**,
- estensibilità verso **Verifiable Credentials** compatibili con l’ecosistema Europass / ELM.

Radicle ORF è pensato per essere semplice da adottare, solido da integrare e trasparente da spiegare.

---

## Obiettivi

- **Open & interoperabile**  
  Formato documentato e non proprietario, allineabile a Europass, European Learning Model (ELM), schema.org e standard moderni.

- **Multi-tenant by design**  
  Ogni tabella include `tenant_id`, con vincoli che impediscono contaminazioni tra clienti. Ideale per SaaS e ambienti partner.

- **Database-first, API-ready**  
  Il modello nasce su Oracle, ma espone un contratto JSON-LD chiaro, stabile e versionabile, pronto per REST API, integrazioni e front-end.

- **Estendibile verso credenziali digitali**  
  La struttura supporta l’associazione di certificazioni e attestati in formato JSON-LD/VC, senza vincolare chi non ne ha bisogno.

---

## Modello dati (overview)

Entità principali:

- `orf_tenant`  
  Identifica l’organizzazione (cliente, azienda, ente).

- `orf_person`  
  Dati anagrafici della persona (nome, cognome, contatti).

- `orf_profile`  
  Un profilo/CV per persona (titolo, summary, stato, pubblicazione, foto BLOB).

- `orf_experience`  
  Esperienze lavorative.

- `orf_education`  
  Titoli di studio e percorsi formativi.

- `orf_skill` + `orf_profile_skill`  
  Catalogo skill + associazioni ai profili, con possibilità di collegamento a ESCO o altri vocabolari.

- `orf_language`  
  Competenze linguistiche strutturate.

- `orf_profile_link`  
  Link esterni (LinkedIn, portfolio, GitHub, ecc.).

- `orf_project`  
  Progetti significativi.

- `orf_credential`  
  Certificazioni e attestati, con possibilità di memorizzare anche la rappresentazione JSON-LD/VC.

Caratteristiche tecniche chiave:

- PK ovunque = `id`
- `tenant_id` su tutte le tabelle ORF
- FK composite `(tenant_id, id)` per garantire coerenza multi-tenant
- Metadati tecnici standard:
  - `created`, `created_by`, `updated`, `updated_by` (gestiti via trigger)
- Supporto foto profilo:
  - `photo` (BLOB) + `photo_mime_type` in `orf_profile`
  - esposizione tramite endpoint dedicato

Dettagli completi: vedi [`/docs/data-model.md`](docs/data-model.md).

---

## Formato JSON-LD: Open Resume Document

Ogni profilo viene esposto come **documento JSON-LD** secondo Open Resume 2.0, ad esempio via Oracle JSON Relational Duality Views.

Caratteristiche:

- `@context` che include:
  - W3C Verifiable Credentials
  - Europass / ELM (dove applicabile)
  - schema.org
  - `https://radicle.services/openresume/context/v2`
- `credentialSubject` con:
  - dati della persona
  - esperienze
  - education
  - skill
  - lingue
  - link
  - progetti
  - credenziali
  - immagine profilo (`image`) come URL verso API sicura

Esempio completo: [`/examples/openresume-sample.json`](examples/openresume-sample.json).

Questo JSON è:

- leggibile come normale JSON dai sistemi non semantici,
- arricchito semanticamente per chi usa Linked Data / ELM / Europass.

---

## Sicurezza e multitenancy

Radicle ORF implementa il multitenant con:

- colonna `tenant_id` in tutte le tabelle,
- vincoli FK `(tenant_id, fk_id)` → `(tenant_id, id)` sui parent,
- trigger standard che:
  - impostano `tenant_id` da contesto applicativo (es. `RADICLE_CTX` o APEX session),
  - valorizzano `created/created_by/updated/updated_by`,
  - non eseguono SELECT interne.

In questo modo:

- ogni richiesta opera nel proprio tenant,
- il database impedisce riferimenti incrociati tra tenant,
- le API e le Duality View filtrano automaticamente per `tenant_id`.

---

## Duality View & API

Il progetto fornisce:

- una **JSON Relational Duality View** (`orf_openresume_v`) che:
  - aggrega i dati del profilo in un singolo JSON-LD,
  - è filtrata per `tenant_id`,
  - è definita con `WITH INSERT, UPDATE, DELETE` per abilitare CRUD JSON-based.

- esempi di endpoint REST (ORDS/APEX):

  - `GET /api/orf/profiles/{id}` → Open Resume JSON-LD
  - `GET /api/orf/profiles/{id}/photo` → foto profilo
  - `GET /api/orf/profiles` → elenco profili del tenant

Specifiche: vedi [`/api/openapi.yaml`](api/openapi.yaml).

---

## Struttura del repository

```text
radicle-open-resume-2.0/
├─ README.md
├─ docs/
│  ├─ spec-overview.md
│  ├─ data-model.md
│  ├─ jsonld-spec.md
│  └─ integration-guide.md
├─ db/
│  ├─ schema/
│  │  ├─ 00_orf_tenant.sql
│  │  ├─ 10_orf_core.sql
│  │  └─ 20_orf_extensions.sql
│  ├─ triggers/
│  │  └─ orf_standard_triggers.sql
│  ├─ dual_views/
│  │  └─ orf_openresume_v.sql
├─ api/
│  ├─ openapi.yaml
│  └─ ords-handlers.sql
├─ examples/
│  ├─ openresume-sample.json
│  └─ postman_collection.json
└─ apex/
   ├─ app_export.sql
   └─ notes.md


