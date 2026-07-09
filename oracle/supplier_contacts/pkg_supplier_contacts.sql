-- =============================================================================
-- Package : PKG_SUPPLIER_CONTACTS
-- Description : Oracle EBS R12 - Supplier Contacts CRUD
--               Uses AP_VENDOR_PUB_PKG, HZ_PARTY_V2PUB (TCA), FND APIs
-- Schema  : APPS
-- =============================================================================

CREATE OR REPLACE PACKAGE pkg_supplier_contacts AS

    -- Create a new supplier contact
    PROCEDURE create_supplier_contact (
        p_vendor_id          IN  NUMBER,
        p_vendor_site_id     IN  NUMBER,
        p_first_name         IN  VARCHAR2,
        p_last_name          IN  VARCHAR2,
        p_email_address      IN  VARCHAR2,
        p_phone_number       IN  VARCHAR2,   -- format: AAANNNNNNN (3-digit area code)
        p_job_title          IN  VARCHAR2    DEFAULT NULL,
        x_vendor_contact_id  OUT NUMBER,
        x_return_status      OUT VARCHAR2,
        x_msg_count          OUT NUMBER,
        x_msg_data           OUT VARCHAR2
    );

    -- Update an existing supplier contact
    PROCEDURE update_supplier_contact (
        p_vendor_contact_id  IN  NUMBER,
        p_first_name         IN  VARCHAR2    DEFAULT NULL,
        p_last_name          IN  VARCHAR2    DEFAULT NULL,
        p_email_address      IN  VARCHAR2    DEFAULT NULL,
        p_phone_number       IN  VARCHAR2    DEFAULT NULL,
        p_job_title          IN  VARCHAR2    DEFAULT NULL,
        x_return_status      OUT VARCHAR2,
        x_msg_count          OUT NUMBER,
        x_msg_data           OUT VARCHAR2
    );

    -- Soft-delete: set inactive_date = SYSDATE
    PROCEDURE inactivate_supplier_contact (
        p_vendor_contact_id  IN  NUMBER,
        x_return_status      OUT VARCHAR2,
        x_msg_count          OUT NUMBER,
        x_msg_data           OUT VARCHAR2
    );

    -- Return all contacts for a vendor (optionally filtered by site)
    PROCEDURE get_supplier_contacts (
        p_vendor_id      IN  NUMBER,
        p_vendor_site_id IN  NUMBER         DEFAULT NULL,
        x_contacts       OUT SYS_REFCURSOR
    );

END pkg_supplier_contacts;
/

-- =============================================================================
-- Package Body
-- =============================================================================

CREATE OR REPLACE PACKAGE BODY pkg_supplier_contacts AS

    -- -------------------------------------------------------------------------
    -- Private helper: dump FND message stack to DBMS_OUTPUT
    -- -------------------------------------------------------------------------
    PROCEDURE log_messages (p_msg_count IN NUMBER, p_msg_data IN VARCHAR2) IS
        l_msg VARCHAR2(4000);
    BEGIN
        IF p_msg_count = 1 THEN
            DBMS_OUTPUT.PUT_LINE('API Message: ' || p_msg_data);
        ELSIF p_msg_count > 1 THEN
            FOR i IN 1 .. p_msg_count LOOP
                l_msg := FND_MSG_PUB.GET(p_msg_index => i, p_encoded => 'F');
                DBMS_OUTPUT.PUT_LINE('API Message [' || i || ']: ' || l_msg);
            END LOOP;
        END IF;
    END log_messages;

    -- =========================================================================
    -- CREATE
    -- =========================================================================
    PROCEDURE create_supplier_contact (
        p_vendor_id          IN  NUMBER,
        p_vendor_site_id     IN  NUMBER,
        p_first_name         IN  VARCHAR2,
        p_last_name          IN  VARCHAR2,
        p_email_address      IN  VARCHAR2,
        p_phone_number       IN  VARCHAR2,
        p_job_title          IN  VARCHAR2    DEFAULT NULL,
        x_vendor_contact_id  OUT NUMBER,
        x_return_status      OUT VARCHAR2,
        x_msg_count          OUT NUMBER,
        x_msg_data           OUT VARCHAR2
    ) IS
        l_vendor_contact_rec  AP_VENDOR_PUB_PKG.r_vendor_contact_rec_type;
        l_per_party_id        NUMBER;
        l_rel_party_id        NUMBER;
        l_rel_id              NUMBER;
        l_org_contact_id      NUMBER;
        l_party_site_id       NUMBER;
    BEGIN
        FND_MSG_PUB.INITIALIZE;

        -- Set up FND apps context if running outside a responsibility
        -- FND_GLOBAL.APPS_INITIALIZE(user_id, resp_id, resp_appl_id);

        l_vendor_contact_rec.vendor_id       := p_vendor_id;
        l_vendor_contact_rec.vendor_site_id  := p_vendor_site_id;
        l_vendor_contact_rec.first_name      := p_first_name;
        l_vendor_contact_rec.last_name       := p_last_name;
        l_vendor_contact_rec.title           := p_job_title;
        l_vendor_contact_rec.email_address   := p_email_address;
        l_vendor_contact_rec.area_code       := SUBSTR(p_phone_number, 1, 3);
        l_vendor_contact_rec.phone           := SUBSTR(p_phone_number, 4);
        l_vendor_contact_rec.inactive_date   := NULL;

        AP_VENDOR_PUB_PKG.Create_Vendor_Contact (
            p_api_version        => 1.0,
            p_init_msg_list      => FND_API.G_TRUE,
            p_commit             => FND_API.G_FALSE,
            p_vendor_contact     => l_vendor_contact_rec,
            x_vendor_contact_id  => x_vendor_contact_id,
            x_per_party_id       => l_per_party_id,
            x_rel_party_id       => l_rel_party_id,
            x_rel_id             => l_rel_id,
            x_org_contact_id     => l_org_contact_id,
            x_party_site_id      => l_party_site_id,
            x_return_status      => x_return_status,
            x_msg_count          => x_msg_count,
            x_msg_data           => x_msg_data
        );

        IF x_return_status = FND_API.G_RET_STS_SUCCESS THEN
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('SUCCESS - Vendor Contact ID: ' || x_vendor_contact_id);
        ELSE
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR - create_supplier_contact failed.');
            log_messages(x_msg_count, x_msg_data);
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            x_return_status := FND_API.G_RET_STS_UNEXP_ERROR;
            x_msg_data      := 'UNEXPECTED: ' || SQLERRM;
            DBMS_OUTPUT.PUT_LINE(x_msg_data);
    END create_supplier_contact;

    -- =========================================================================
    -- UPDATE
    -- =========================================================================
    PROCEDURE update_supplier_contact (
        p_vendor_contact_id  IN  NUMBER,
        p_first_name         IN  VARCHAR2    DEFAULT NULL,
        p_last_name          IN  VARCHAR2    DEFAULT NULL,
        p_email_address      IN  VARCHAR2    DEFAULT NULL,
        p_phone_number       IN  VARCHAR2    DEFAULT NULL,
        p_job_title          IN  VARCHAR2    DEFAULT NULL,
        x_return_status      OUT VARCHAR2,
        x_msg_count          OUT NUMBER,
        x_msg_data           OUT VARCHAR2
    ) IS
        l_person_rec          HZ_PARTY_V2PUB.person_rec_type;
        l_obj_version_number  NUMBER;
        l_party_id            NUMBER;
        l_profile_id          NUMBER;
    BEGIN
        FND_MSG_PUB.INITIALIZE;

        BEGIN
            SELECT asc2.per_party_id,
                   hp.object_version_number
            INTO   l_party_id,
                   l_obj_version_number
            FROM   ap_supplier_contacts asc2
            JOIN   hz_parties           hp  ON hp.party_id = asc2.per_party_id
            WHERE  asc2.vendor_contact_id = p_vendor_contact_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                x_return_status := FND_API.G_RET_STS_ERROR;
                x_msg_data      := 'Contact ID ' || p_vendor_contact_id || ' not found.';
                DBMS_OUTPUT.PUT_LINE(x_msg_data);
                RETURN;
        END;

        l_person_rec.party_rec.party_id := l_party_id;
        l_person_rec.first_name         := p_first_name;
        l_person_rec.last_name          := p_last_name;
        l_person_rec.job_title          := p_job_title;

        HZ_PARTY_V2PUB.UPDATE_PERSON (
            p_init_msg_list               => FND_API.G_FALSE,
            p_person_rec                  => l_person_rec,
            p_party_object_version_number => l_obj_version_number,
            x_profile_id                  => l_profile_id,
            x_return_status               => x_return_status,
            x_msg_count                   => x_msg_count,
            x_msg_data                    => x_msg_data
        );

        IF x_return_status <> FND_API.G_RET_STS_SUCCESS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR - HZ_PARTY_V2PUB.UPDATE_PERSON failed.');
            log_messages(x_msg_count, x_msg_data);
            RETURN;
        END IF;

        UPDATE ap_supplier_contacts
        SET    email_address    = NVL(p_email_address, email_address),
               area_code        = NVL(SUBSTR(p_phone_number, 1, 3), area_code),
               phone            = NVL(SUBSTR(p_phone_number, 4),    phone),
               last_update_date = SYSDATE,
               last_updated_by  = FND_GLOBAL.USER_ID
        WHERE  vendor_contact_id = p_vendor_contact_id;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('SUCCESS - Contact ' || p_vendor_contact_id || ' updated.');

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            x_return_status := FND_API.G_RET_STS_UNEXP_ERROR;
            x_msg_data      := 'UNEXPECTED: ' || SQLERRM;
            DBMS_OUTPUT.PUT_LINE(x_msg_data);
    END update_supplier_contact;

    -- =========================================================================
    -- INACTIVATE (soft-delete)
    -- =========================================================================
    PROCEDURE inactivate_supplier_contact (
        p_vendor_contact_id  IN  NUMBER,
        x_return_status      OUT VARCHAR2,
        x_msg_count          OUT NUMBER,
        x_msg_data           OUT VARCHAR2
    ) IS
        l_count NUMBER := 0;
    BEGIN
        FND_MSG_PUB.INITIALIZE;

        SELECT COUNT(1) INTO l_count
        FROM   ap_supplier_contacts
        WHERE  vendor_contact_id = p_vendor_contact_id;

        IF l_count = 0 THEN
            x_return_status := FND_API.G_RET_STS_ERROR;
            x_msg_data      := 'Contact ID ' || p_vendor_contact_id || ' not found.';
            DBMS_OUTPUT.PUT_LINE(x_msg_data);
            RETURN;
        END IF;

        UPDATE ap_supplier_contacts
        SET    inactive_date    = TRUNC(SYSDATE),
               last_update_date = SYSDATE,
               last_updated_by  = FND_GLOBAL.USER_ID
        WHERE  vendor_contact_id = p_vendor_contact_id;

        COMMIT;
        x_return_status := FND_API.G_RET_STS_SUCCESS;
        x_msg_count     := 0;
        DBMS_OUTPUT.PUT_LINE('SUCCESS - Contact ' || p_vendor_contact_id || ' inactivated.');

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            x_return_status := FND_API.G_RET_STS_UNEXP_ERROR;
            x_msg_data      := 'UNEXPECTED: ' || SQLERRM;
            DBMS_OUTPUT.PUT_LINE(x_msg_data);
    END inactivate_supplier_contact;

    -- =========================================================================
    -- QUERY
    -- =========================================================================
    PROCEDURE get_supplier_contacts (
        p_vendor_id      IN  NUMBER,
        p_vendor_site_id IN  NUMBER         DEFAULT NULL,
        x_contacts       OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN x_contacts FOR
            SELECT asc2.vendor_contact_id,
                   asc2.vendor_id,
                   pv.vendor_name,
                   asc2.vendor_site_id,
                   pvs.vendor_site_code,
                   hp.person_first_name                               AS first_name,
                   hp.person_last_name                                AS last_name,
                   hp.person_first_name || ' ' || hp.person_last_name AS full_name,
                   asc2.title                                         AS job_title,
                   asc2.email_address,
                   asc2.area_code || '-' || asc2.phone                AS phone,
                   asc2.fax_area_code || '-' || asc2.fax              AS fax,
                   asc2.inactive_date,
                   CASE
                       WHEN asc2.inactive_date IS NULL
                            OR asc2.inactive_date > TRUNC(SYSDATE)
                       THEN 'Active'
                       ELSE 'Inactive'
                   END                                                AS status,
                   asc2.creation_date,
                   asc2.last_update_date
            FROM   ap_supplier_contacts  asc2
            JOIN   ap_suppliers          pv   ON pv.vendor_id        = asc2.vendor_id
            JOIN   ap_supplier_sites_all pvs  ON pvs.vendor_site_id  = asc2.vendor_site_id
            JOIN   hz_relationships      hr   ON hr.party_id         = asc2.rel_party_id
                                             AND hr.directional_flag  = 'F'
                                             AND hr.status            = 'A'
            JOIN   hz_parties            hp   ON hp.party_id         = hr.subject_id
            WHERE  asc2.vendor_id = p_vendor_id
              AND  (p_vendor_site_id IS NULL
                    OR asc2.vendor_site_id = p_vendor_site_id)
            ORDER  BY hp.person_last_name, hp.person_first_name;
    END get_supplier_contacts;

END pkg_supplier_contacts;
/
