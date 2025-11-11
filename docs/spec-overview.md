Entità principali

orf_tenant
Identifica l’organizzazione / cliente.

orf_person
Dati anagrafici del candidato/utente.

orf_profile
Un CV/profilo per persona, con stato (DRAFT / PUBLISHED / ARCHIVED), pubblicazione e foto.

orf_experience
Esperienze lavorative.

orf_education
Titoli di studio / formazione.

orf_skill + orf_profile_skill
Skill strutturate, con eventuale link ad ESCO.

orf_language
Competenze linguistiche.

orf_profile_link
Link a portfolio, GitHub, LinkedIn, ecc.

orf_project
Progetti significativi.

orf_credential
Certificazioni / attestati, con hook per JSON-LD Verifiable Credential.

Caratteristiche tecniche

PK ovunque = id

tenant_id in tutte le tabelle ORF → multi-tenant forte

FK composite (tenant_id, fk_id) → nessuna contaminazione tra clienti

Metadati tecnici standard:

created, created_by, updated, updated_by (a trigger, no logica business)

Foto profilo:

orf_profile.photo (BLOB) + photo_mime_type

esposta via endpoint dedicato, referenziata nel JSON come image.
