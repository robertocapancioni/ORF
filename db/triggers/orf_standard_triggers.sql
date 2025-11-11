--------------------------------------------------------------------------------
-- Radicle Open Resume 2.0
-- Trigger standard ORF: tenant_id + metadati created/updated
-- NOTE:
--  - Nessuna SELECT nei trigger
--  - TENANT_ID letto da:
--        RADICLE_CTX.TENANT_ID
--    (fallback opzionale: APEX$SESSION.APP_TENANT_ID)
--  - In INSERT:
--        se :NEW.tenant_id è NULL -> prende dal context
--        se ancora NULL -> errore
--  - In UPDATE:
--        tenant_id NON viene mai toccato
--  - Metadati tecnici:
--        created/created_by valorizzati solo in INSERT se null
--        updated/updated_by sempre in INSERT/UPDATE
--------------------------------------------------------------------------------

-- Helper macro mentale (stesso blocco usato su tutte le tabelle):
-- l_user       := NVL(sys_context('APEX$SESSION','APP_USER'), USER);
-- l_ctx_tenant := NVL(
--                     NULLIF(sys_context('RADICLE_CTX','TENANT_ID'), ''),
--                     NULLIF(sys_context('APEX$SESSION','APP_TENANT_ID'), '')
--                 );
-- l_tenant_id  := NVL(
--                     :NEW.tenant_id,
--                     CASE
--                         WHEN l_ctx_tenant IS NOT NULL
--                         THEN TO_NUMBER(l_ctx_tenant)
--                         ELSE NULL
--                     END
--                 );
-- IF INSERTING THEN
--   IF l_tenant_id IS NULL THEN raise_application_error(...); END IF;
--   :NEW.tenant_id := l_tenant_id;
--   IF :NEW.created    IS NULL THEN :NEW.created    := SYSTIMESTAMP; END IF;
--   IF :NEW.created_by IS NULL THEN :NEW.created_by := l_user;        END IF;
-- END IF;
-- :NEW.updated    := SYSTIMESTAMP;
-- :NEW.updated_by := l_user;

--------------------------------------------------------------------------------
-- orf_person
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER orf_person_biu
BEFORE INSERT OR UPDATE ON orf_person
FOR EACH ROW
DECLARE
    l_user       VARCHAR2(256) := NVL(sys_context('APEX$SESSION','APP_USER'), USER);
    l_ctx_tenant VARCHAR2(4000) := NVL(
                         NULLIF(sys_context('RADICLE_CTX','TENANT_ID'), ''),
                         NULLIF(sys_context('APEX$SESSION','APP_TENANT_ID'), '')
                     );
    l_tenant_id  NUMBER := NVL(
                         :NEW.tenant_id,
                         CASE
                             WHEN l_ctx_tenant IS NOT NULL
                             THEN TO_NUMBER(l_ctx_tenant)
                             ELSE NULL
                         END
                     );
BEGIN
    IF INSERTING THEN
        IF l_tenant_id IS NULL THEN
            raise_application_error(-20000, 'TENANT_ID non valorizzato (orf_person)');
        END IF;

        :NEW.tenant_id := l_tenant_id;

        IF :NEW.created IS NULL THEN
            :NEW.created := SYSTIMESTAMP;
        END IF;
        IF :NEW.created_by IS NULL THEN
            :NEW.created_by := l_user;
        END IF;
    END IF;

    :NEW.updated    := SYSTIMESTAMP;
    :NEW.updated_by := l_user;
END;
/
--------------------------------------------------------------------------------
-- orf_profile
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER orf_profile_biu
BEFORE INSERT OR UPDATE ON orf_profile
FOR EACH ROW
DECLARE
    l_user       VARCHAR2(256) := NVL(sys_context('APEX$SESSION','APP_USER'), USER);
    l_ctx_tenant VARCHAR2(4000) := NVL(
                         NULLIF(sys_context('RADICLE_CTX','TENANT_ID'), ''),
                         NULLIF(sys_context('APEX$SESSION','APP_TENANT_ID'), '')
                     );
    l_tenant_id  NUMBER := NVL(
                         :NEW.tenant_id,
                         CASE
                             WHEN l_ctx_tenant IS NOT NULL
                             THEN TO_NUMBER(l_ctx_tenant)
                             ELSE NULL
                         END
                     );
BEGIN
    IF INSERTING THEN
        IF l_tenant_id IS NULL THEN
            raise_application_error(-20000, 'TENANT_ID non valorizzato (orf_profile)');
        END IF;

        :NEW.tenant_id := l_tenant_id;

        IF :NEW.created IS NULL THEN
            :NEW.created := SYSTIMESTAMP;
        END IF;
        IF :NEW.created_by IS NULL THEN
            :NEW.created_by := l_user;
        END IF;
    END IF;

    :NEW.updated    := SYSTIMESTAMP;
    :NEW.updated_by := l_user;
END;
/
--------------------------------------------------------------------------------
-- orf_experience
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER orf_experience_biu
BEFORE INSERT OR UPDATE ON orf_experience
FOR EACH ROW
DECLARE
    l_user       VARCHAR2(256) := NVL(sys_context('APEX$SESSION','APP_USER'), USER);
    l_ctx_tenant VARCHAR2(4000) := NVL(
                         NULLIF(sys_context('RADICLE_CTX','TENANT_ID'), ''),
                         NULLIF(sys_context('APEX$SESSION','APP_TENANT_ID'), '')
                     );
    l_tenant_id  NUMBER := NVL(
                         :NEW.tenant_id,
                         CASE
                             WHEN l_ctx_tenant IS NOT NULL
                             THEN TO_NUMBER(l_ctx_tenant)
                             ELSE NULL
                         END
                     );
BEGIN
    IF INSERTING THEN
        IF l_tenant_id IS NULL THEN
            raise_application_error(-20000, 'TENANT_ID non valorizzato (orf_experience)');
        END IF;

        :NEW.tenant_id := l_tenant_id;

        IF :NEW.created IS NULL THEN
            :NEW.created := SYSTIMESTAMP;
        END IF;
        IF :NEW.created_by IS NULL THEN
            :NEW.created_by := l_user;
        END IF;
    END IF;

    :NEW.updated    := SYSTIMESTAMP;
    :NEW.updated_by := l_user;
END;
/
--------------------------------------------------------------------------------
-- orf_education
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER orf_education_biu
BEFORE INSERT OR UPDATE ON orf_education
FOR EACH ROW
DECLARE
    l_user       VARCHAR2(256) := NVL(sys_context('APEX$SESSION','APP_USER'), USER);
    l_ctx_tenant VARCHAR2(4000) := NVL(
                         NULLIF(sys_context('RADICLE_CTX','TENANT_ID'), ''),
                         NULLIF(sys_context('APEX$SESSION','APP_TENANT_ID'), '')
                     );
    l_tenant_id  NUMBER := NVL(
                         :NEW.tenant_id,
                         CASE
                             WHEN l_ctx_tenant IS NOT NULL
                             THEN TO_NUMBER(l_ctx_tenant)
                             ELSE NULL
                         END
                     );
BEGIN
    IF INSERTING THEN
        IF l_tenant_id IS NULL THEN
            raise_application_error(-20000, 'TENANT_ID non valorizzato (orf_education)');
        END IF;

        :NEW.tenant_id := l_tenant_id;

        IF :NEW.created IS NULL THEN
            :NEW.created := SYSTIMESTAMP;
        END IF;
        IF :NEW.created_by IS NULL THEN
            :NEW.created_by := l_user;
        END IF;
    END IF;

    :NEW.updated    := SYSTIMESTAMP;
    :NEW.updated_by := l_user;
END;
/
--------------------------------------------------------------------------------
-- orf_skill
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER orf_skill_biu
BEFORE INSERT OR UPDATE ON orf_skill
FOR EACH ROW
DECLARE
    l_user       VARCHAR2(256) := NVL(sys_context('APEX$SESSION','APP_USER'), USER);
    l_ctx_tenant VARCHAR2(4000) := NVL(
                         NULLIF(sys_context('RADICLE_CTX','TENANT_ID'), ''),
                         NULLIF(sys_context('APEX$SESSION','APP_TENANT_ID'), '')
                     );
    l_tenant_id  NUMBER := NVL(
                         :NEW.tenant_id,
                         CASE
                             WHEN l_ctx_tenant IS NOT NULL
                             THEN TO_NUMBER(l_ctx_tenant)
                             ELSE NULL
                         END
                     );
BEGIN
    IF INSERTING THEN
        IF l_tenant_id IS NULL THEN
            raise_application_error(-20000, 'TENANT_ID non valorizzato (orf_skill)');
        END IF;

        :NEW.tenant_id := l_tenant_id;

        IF :NEW.created IS NULL THEN
            :NEW.created := SYSTIMESTAMP;
        END IF;
        IF :NEW.created_by IS NULL THEN
            :NEW.created_by := l_user;
        END IF;
    END IF;

    :NEW.updated    := SYSTIMESTAMP;
    :NEW.updated_by := l_user;
END;
/
--------------------------------------------------------------------------------
-- orf_profile_skill
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER orf_profile_skill_biu
BEFORE INSERT OR UPDATE ON orf_profile_skill
FOR EACH ROW
DECLARE
    l_user       VARCHAR2(256) := NVL(sys_context('APEX$SESSION','APP_USER'), USER);
    l_ctx_tenant VARCHAR2(4000) := NVL(
                         NULLIF(sys_context('RADICLE_CTX','TENANT_ID'), ''),
                         NULLIF(sys_context('APEX$SESSION','APP_TENANT_ID'), '')
                     );
    l_tenant_id  NUMBER := NVL(
                         :NEW.tenant_id,
                         CASE
                             WHEN l_ctx_tenant IS NOT NULL
                             THEN TO_NUMBER(l_ctx_tenant)
                             ELSE NULL
                         END
                     );
BEGIN
    IF INSERTING THEN
        IF l_tenant_id IS NULL THEN
            raise_application_error(-20000, 'TENANT_ID non valorizzato (orf_profile_skill)');
        END IF;

        :NEW.tenant_id := l_tenant_id;

        IF :NEW.created IS NULL THEN
            :NEW.created := SYSTIMESTAMP;
        END IF;
        IF :NEW.created_by IS NULL THEN
            :NEW.created_by := l_user;
        END IF;
    END IF;

    :NEW.updated    := SYSTIMESTAMP;
    :NEW.updated_by := l_user;
END;
/
--------------------------------------------------------------------------------
-- orf_language
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER orf_language_biu
BEFORE INSERT OR UPDATE ON orf_language
FOR EACH ROW
DECLARE
    l_user       VARCHAR2(256) := NVL(sys_context('APEX$SESSION','APP_USER'), USER);
    l_ctx_tenant VARCHAR2(4000) := NVL(
                         NULLIF(sys_context('RADICLE_CTX','TENANT_ID'), ''),
                         NULLIF(sys_context('APEX$SESSION','APP_TENANT_ID'), '')
                     );
    l_tenant_id  NUMBER := NVL(
                         :NEW.tenant_id,
                         CASE
                             WHEN l_ctx_tenant IS NOT NULL
                             THEN TO_NUMBER(l_ctx_tenant)
                             ELSE NULL
                         END
                     );
BEGIN
    IF INSERTING THEN
        IF l_tenant_id IS NULL THEN
            raise_application_error(-20000, 'TENANT_ID non valorizzato (orf_language)');
        END IF;

        :NEW.tenant_id := l_tenant_id;

        IF :NEW.created IS NULL THEN
            :NEW.created := SYSTIMESTAMP;
        END IF;
        IF :NEW.created_by IS NULL THEN
            :NEW.created_by := l_user;
        END IF;
    END IF;

    :NEW.updated    := SYSTIMESTAMP;
    :NEW.updated_by := l_user;
END;
/
--------------------------------------------------------------------------------
-- orf_profile_link
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER orf_profile_link_biu
BEFORE INSERT OR UPDATE ON orf_profile_link
FOR EACH ROW
DECLARE
    l_user       VARCHAR2(256) := NVL(sys_context('APEX$SESSION','APP_USER'), USER);
    l_ctx_tenant VARCHAR2(4000) := NVL(
                         NULLIF(sys_context('RADICLE_CTX','TENANT_ID'), ''),
                         NULLIF(sys_context('APEX$SESSION','APP_TENANT_ID'), '')
                     );
    l_tenant_id  NUMBER := NVL(
                         :NEW.tenant_id,
                         CASE
                             WHEN l_ctx_tenant IS NOT NULL
                             THEN TO_NUMBER(l_ctx_tenant)
                             ELSE NULL
                         END
                     );
BEGIN
    IF INSERTING THEN
        IF l_tenant_id IS NULL THEN
            raise_application_error(-20000, 'TENANT_ID non valorizzato (orf_profile_link)');
        END IF;

        :NEW.tenant_id := l_tenant_id;

        IF :NEW.created IS NULL THEN
            :NEW.created := SYSTIMESTAMP;
        END IF;
        IF :NEW.created_by IS NULL THEN
            :NEW.created_by := l_user;
        END IF;
    END IF;

    :NEW.updated    := SYSTIMESTAMP;
    :NEW.updated_by := l_user;
END;
/
--------------------------------------------------------------------------------
-- orf_project
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER orf_project_biu
BEFORE INSERT OR UPDATE ON orf_project
FOR EACH ROW
DECLARE
    l_user       VARCHAR2(256) := NVL(sys_context('APEX$SESSION','APP_USER'), USER);
    l_ctx_tenant VARCHAR2(4000) := NVL(
                         NULLIF(sys_context('RADICLE_CTX','TENANT_ID'), ''),
                         NULLIF(sys_context('APEX$SESSION','APP_TENANT_ID'), '')
                     );
    l_tenant_id  NUMBER := NVL(
                         :NEW.tenant_id,
                         CASE
                             WHEN l_ctx_tenant IS NOT NULL
                             THEN TO_NUMBER(l_ctx_tenant)
                             ELSE NULL
                         END
                     );
BEGIN
    IF INSERTING THEN
        IF l_tenant_id IS NULL THEN
            raise_application_error(-20000, 'TENANT_ID non valorizzato (orf_project)');
        END IF;

        :NEW.tenant_id := l_tenant_id;

        IF :NEW.created IS NULL THEN
            :NEW.created := SYSTIMESTAMP;
        END IF;
        IF :NEW.created_by IS NULL THEN
            :NEW.created_by := l_user;
        END IF;
    END IF;

    :NEW.updated    := SYSTIMESTAMP;
    :NEW.updated_by := l_user;
END;
/
--------------------------------------------------------------------------------
-- orf_credential
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER orf_credential_biu
BEFORE INSERT OR UPDATE ON orf_credential
FOR EACH ROW
DECLARE
    l_user       VARCHAR2(256) := NVL(sys_context('APEX$SESSION','APP_USER'), USER);
    l_ctx_tenant VARCHAR2(4000) := NVL(
                         NULLIF(sys_context('RADICLE_CTX','TENANT_ID'), ''),
                         NULLIF(sys_context('APEX$SESSION','APP_TENANT_ID'), '')
                     );
    l_tenant_id  NUMBER := NVL(
                         :NEW.tenant_id,
                         CASE
                             WHEN l_ctx_tenant IS NOT NULL
                             THEN TO_NUMBER(l_ctx_tenant)
                             ELSE NULL
                         END
                     );
BEGIN
    IF INSERTING THEN
        IF l_tenant_id IS NULL THEN
            raise_application_error(-20000, 'TENANT_ID non valorizzato (orf_credential)');
        END IF;

        :NEW.tenant_id := l_tenant_id;

        IF :NEW.created IS NULL THEN
            :NEW.created := SYSTIMESTAMP;
        END IF;
        IF :NEW.created_by IS NULL THEN
            :NEW.created_by := l_user;
        END IF;
    END IF;

    :NEW.updated    := SYSTIMESTAMP;
    :NEW.updated_by := l_user;
END;
/
