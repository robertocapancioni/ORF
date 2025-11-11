-- Trigger standard per tutte le tabelle ORF
-- Nessuna SELECT, tenant da context/APEX, metadati auto.

-- Utilizza:
-- RADICLE_CTX.TENANT_ID oppure APEX$SESSION.APP_TENANT_ID

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
                         CASE WHEN l_ctx_tenant IS NOT NULL THEN TO_NUMBER(l_ctx_tenant) END
                     );
BEGIN
    IF INSERTING THEN
        IF l_tenant_id IS NULL THEN
            raise_application_error(-20000, 'TENANT_ID non valorizzato');
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
-- Copia/incolla lo stesso trigger per:
-- orf_profile, orf_experience, orf_education, orf_skill,
-- orf_profile_skill, orf_language, orf_profile_link,
-- orf_project, orf_credential
-- cambiando solo il nome tabella nel CREATE TRIGGER e nella clausola ON.
