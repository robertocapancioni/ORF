CREATE OR REPLACE PACKAGE radicle_ctx_pkg AS
    -- Imposta il tenant per la sessione corrente.
    PROCEDURE set_tenant (p_tenant_id IN NUMBER);

    -- Ritorna il tenant corrente come NUMBER (NULL se non impostato).
    FUNCTION get_tenant RETURN NUMBER;

    -- Variante utile se usi codici (es. 'RADICLE', 'CLIENTE_X')
    PROCEDURE set_tenant_by_code (p_tenant_code IN VARCHAR2);
END radicle_ctx_pkg;
/
CREATE OR REPLACE PACKAGE BODY radicle_ctx_pkg AS

    PROCEDURE set_tenant (p_tenant_id IN NUMBER) IS
    BEGIN
        IF p_tenant_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Tenant ID nullo in set_tenant');
        END IF;

        DBMS_SESSION.set_context(
            namespace => 'RADICLE_CTX',
            attribute => 'TENANT_ID',
            value     => TO_CHAR(p_tenant_id)
        );
    END set_tenant;


    FUNCTION get_tenant RETURN NUMBER IS
        l_val VARCHAR2(4000);
    BEGIN
        l_val := SYS_CONTEXT('RADICLE_CTX', 'TENANT_ID');

        IF l_val IS NULL OR TRIM(l_val) IS NULL THEN
            RETURN NULL;
        END IF;

        RETURN TO_NUMBER(l_val);
    EXCEPTION
        WHEN VALUE_ERROR THEN
            RETURN NULL;
    END get_tenant;


    PROCEDURE set_tenant_by_code (p_tenant_code IN VARCHAR2) IS
        l_tenant_id orf_tenant.id%TYPE;
    BEGIN
        IF p_tenant_code IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'Tenant code nullo in set_tenant_by_code');
        END IF;

        SELECT id
          INTO l_tenant_id
          FROM orf_tenant
         WHERE code = p_tenant_code;

        set_tenant(l_tenant_id);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003,
                'Tenant code non valido in set_tenant_by_code: ' || p_tenant_code);
    END set_tenant_by_code;

END radicle_ctx_pkg;
/
