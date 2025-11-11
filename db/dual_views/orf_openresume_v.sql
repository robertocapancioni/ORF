CREATE JSON RELATIONAL DUALITY VIEW orf_openresume_v AS
SELECT JSON{
  '@context' :
    JSON_ARRAY(
      'https://www.w3.org/2018/credentials/v1',
      'https://europa.eu/europass/credentials/v3',
      'https://schema.org',
      'https://radicle.services/openresume/context/v2'
    ),
  'id'   : 'urn:orf:profile:' || p.id,
  'type' : JSON_ARRAY('OpenResumeProfile'),
  'issuer' : JSON{
      'id'   : 'https://radicle.services',
      'name' : 'Radicle'
  },
  'issuanceDate' :
      TO_CHAR(
        COALESCE(p.published_at, p.created, SYSTIMESTAMP),
        'YYYY-MM-DD"T"HH24:MI:SS"Z"'
      ),
  'credentialSubject' : JSON{
      'id'         : 'urn:orf:person:' || per.id,
      'type'       : JSON_ARRAY('Person'),
      'givenName'  : per.given_name,
      'familyName' : per.family_name,
      'email'      : per.email,
      'address'    : JSON{ 'addressCountry' : per.country_code },
      'title'      : p.title,
      'summary'    : p.summary,
      'status'     : p.status,
      'image' :
          CASE
              WHEN p.photo IS NOT NULL THEN
                  'https://api.radicle.services/orf/profile/' || p.id || '/photo'
              ELSE
                  NULL
          END,

      'workExperience' :
        [ SELECT JSON{
              'id'         : 'urn:orf:exp:' || e.id,
              'type'       : 'WorkExperience',
              'employer'   : e.employer_name,
              'jobTitle'   : e.job_title,
              'startDate'  : TO_CHAR(e.start_date,'YYYY-MM'),
              'endDate'    : CASE
                               WHEN e.end_date IS NOT NULL
                               THEN TO_CHAR(e.end_date,'YYYY-MM')
                               ELSE NULL
                             END,
              'description': e.description
          }
          FROM orf_experience e
          WHERE e.tenant_id = p.tenant_id
            AND e.profile_id = p.id
        ],

      'education' :
        [ SELECT JSON{
              'id'          : 'urn:orf:edu:' || ed.id,
              'type'        : 'LearningAchievement',
              'title'       : ed.program_title,
              'awardingBody': ed.institution,
              'eqfLevel'    : ed.eqf_level,
              'startDate'   : TO_CHAR(ed.start_date,'YYYY-MM'),
              'endDate'     : TO_CHAR(ed.end_date,'YYYY-MM'),
              'description' : ed.description
          }
          FROM orf_education ed
          WHERE ed.tenant_id = p.tenant_id
            AND ed.profile_id = p.id
        ],

      'skills' :
        [ SELECT JSON{
              'id'              : 'urn:orf:skill:' || s.id,
              'type'            : 'Skill',
              'preferredLabel'  : s.label,
              'proficiencyLevel': ps.proficiency_level,
              'escoUri'         : s.esco_uri
          }
          FROM orf_profile_skill ps
          JOIN orf_skill s
            ON s.tenant_id = ps.tenant_id
           AND s.id        = ps.skill_id
          WHERE ps.tenant_id = p.tenant_id
            AND ps.profile_id = p.id
        ],

      'languages' :
        [ SELECT JSON{
              'type'       : 'LanguageSkill',
              'lang'       : l.lang_code,
              'proficiency': l.proficiency,
              'isNative'   : l.is_native
          }
          FROM orf_language l
          WHERE l.tenant_id = p.tenant_id
            AND l.profile_id = p.id
        ],

      'links' :
        [ SELECT JSON{
              'type' : 'WebPage',
              'label': pl.label,
              'url'  : pl.url
          }
          FROM orf_profile_link pl
          WHERE pl.tenant_id = p.tenant_id
            AND pl.profile_id = p.id
        ],

      'projects' :
        [ SELECT JSON{
              'id'         : 'urn:orf:project:' || pr.id,
              'name'       : pr.name,
              'role'       : pr.role,
              'startDate'  : TO_CHAR(pr.start_date,'YYYY-MM'),
              'endDate'    : TO_CHAR(pr.end_date,'YYYY-MM'),
              'description': pr.description
          }
          FROM orf_project pr
          WHERE pr.tenant_id = p.tenant_id
            AND pr.profile_id = p.id
        ],

      'credentials' :
        [ SELECT JSON{
              'id'         : 'urn:orf:credential:' || c.id,
              'type'       : c.type,
              'title'      : c.title,
              'issuerName' : c.issuer_name,
              'issueDate'  : TO_CHAR(c.issue_date,'YYYY-MM-DD'),
              'expiryDate' : TO_CHAR(c.expiry_date,'YYYY-MM-DD')
          }
          FROM orf_credential c
          WHERE c.tenant_id = p.tenant_id
            AND c.profile_id = p.id
        ]
  }
}
FROM orf_profile p
JOIN orf_person per
  ON per.tenant_id = p.tenant_id
 AND per.id        = p.person_id
WHERE p.tenant_id = TO_NUMBER(
        NVL(
          NULLIF(sys_context('RADICLE_CTX','TENANT_ID'), ''),
          NULLIF(sys_context('APEX$SESSION','APP_TENANT_ID'), '')
        )
      )
WITH INSERT, UPDATE, DELETE;
/
