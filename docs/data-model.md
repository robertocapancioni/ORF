# Data Model – Radicle Open Resume 2.0

## Convenzioni

- Tutte le PK: `id`
- Multi-tenant:
  - Ogni tabella ha `tenant_id NOT NULL`
  - FK composite `(tenant_id, fk_id)` → `(tenant_id, id)` della tabella padre
- Metadati tecnici:
  - `created`, `created_by`, `updated`, `updated_by`
  - gestiti via trigger standard
- Eventuali foto:
  - `orf_profile.photo` (BLOB)
  - `orf_profile.photo_mime_type`

## Tabelle

### `orf_tenant`

Identifica il tenant / organizzazione.

- `id` (PK)
- `code` UNIQUE
- `name`

### `orf_person`

Dati anagrafici della persona.

- `id` (PK)
- `tenant_id` (FK → `orf_tenant.id`)
- `given_name`
- `family_name`
- `email`
- `country_code`
- meta: `created`, `created_by`, `updated`, `updated_by`

### `orf_profile`

Un profilo (CV) per persona.

- `id` (PK)
- `tenant_id` (FK → `orf_tenant`)
- `person_id` (FK → `orf_person`)
- `title`
- `summary`
- `status` (es. `DRAFT`, `PUBLISHED`, `ARCHIVED`)
- `published_at`
- `archived_at`
- `photo` (BLOB, opzionale)
- `photo_mime_type`
- meta

### `orf_experience`

Esperienze lavorative.

- `id` (PK)
- `tenant_id`
- `profile_id` (FK → `orf_profile`)
- `employer_name`
- `job_title`
- `start_date`, `end_date`
- `description`
- meta

### `orf_education`

Percorsi formativi.

- `id` (PK)
- `tenant_id`
- `profile_id`
- `institution`
- `program_title`
- `eqf_level`
- `start_date`, `end_date`
- `description`
- meta

### `orf_skill`

Catalogo skill.

- `id` (PK)
- `tenant_id`
- `label`
- `esco_uri`
- `category`
- meta

### `orf_profile_skill`

Associazione profilo-skill.

- `id` (PK)
- `tenant_id`
- `profile_id`
- `skill_id`
- `proficiency_level`
- `evidence`
- meta
- UNIQUE `(tenant_id, profile_id, skill_id)`

### `orf_language`

Competenze linguistiche.

- `id` (PK)
- `tenant_id`
- `profile_id`
- `lang_code`
- `proficiency`
- `is_native`
- meta

### `orf_profile_link`

Link esterni.

- `id` (PK)
- `tenant_id`
- `profile_id`
- `label`
- `url`
- meta

### `orf_project`

Progetti.

- `id` (PK)
- `tenant_id`
- `profile_id`
- `name`
- `role`
- `start_date`, `end_date`
- `description`
- meta

### `orf_credential`

Certificazioni / attestati.

- `id` (PK)
- `tenant_id`
- `profile_id`
- `type`
- `title`
- `issuer_name`
- `issue_date`
- `expiry_date`
- `raw_vc_json` (opzionale)
- meta
