# JSON-LD Specification – Radicle Open Resume 2.0

Questo documento definisce la struttura JSON-LD del **Radicle Open Resume 2.0** (ORF), utilizzata per rappresentare in modo interoperabile un profilo/CV a partire dal modello dati `orf_*` su Oracle.

Obiettivi:

- mantenere il JSON facilmente consumabile da sistemi non “semantici”,
- garantire compatibilità con vocabolari esistenti (W3C VC, Europass/ELM, schema.org),
- consentire evoluzione futura verso Verifiable Credentials.

---

## 1. Contesto (`@context`)

Il documento ORF utilizza un array di contesti per combinare standard esistenti e vocabolario Radicle:

```json
"@context": [
  "https://www.w3.org/2018/credentials/v1",
  "https://europa.eu/europass/credentials/v3",
  "https://schema.org",
  "https://radicle.services/openresume/context/v2"
]
```
Significato:

*   **W3C Verifiable Credentials** – compatibilità con estensioni VC.
    
*   **Europass / ELM** – allineamento con concetti educativi/professionali EU.
    
*   **schema.org** – uso di termini generici (Person, image, ecc.).
    
*   **Radicle Open Resume Context (openresume/context/v2)** – definisce:
    
    *   OpenResumeProfile,
        
    *   mapping dei campi ORF,
        
    *   estensioni proprietarie ma documentate.
        

2\. Root del documento
----------------------

Elemento principale: il profilo ORF.

### 2.1. Campi principali

*   idIdentificatore del profilo.Formato raccomandato: urn:orf:profile:{id} ({id} = orf\_profile.id).
    
*   "type": \["OpenResumeProfile"\]Opzionale (se usato come Verifiable Credential):"type": \["OpenResumeProfile", "VerifiableCredential"\]
    
*   Esempio:"issuer": { "id": "https://radicle.services", "name": "Radicle"}
    
*   issuanceDateData/ora ISO 8601 di emissione del profilo.Tipicamente derivata da:
    
    *   orf\_profile.published\_at, oppure
        
    *   orf\_profile.created come fallback.
        

3\. credentialSubject
---------------------

Contiene i dati della persona e del profilo.

### 3.1. Identità

Campi:

*   idurn:orf:person:{id} (orf\_person.id).
    
*   "type": \["Person"\]
    
*   givenName, familyNameDa orf\_person.
    
*   emailEmail principale.
    
*   address.addressCountryCodice paese (es. "IT"), se presente.
    

Esempio:

```json "credentialSubject": {    "id": "urn:orf:person:42",    "type": ["Person"],    "givenName": "Mario",    "familyName": "Rossi",    "email": "mario.rossi@example.com",    "address": {      "addressCountry": "IT"    }  }
```

### 3.2. Dati di profilo

Campi derivati da orf\_profile:

*   title – headline professionale.
    
*   summary – descrizione sintetica.
    
*   status – DRAFT, PUBLISHED, ARCHIVED, ecc.
    
*   image – URL foto profilo (non inline base64).
    

Esempio:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   "title": "Senior Oracle APEX Consultant",  "summary": "Sviluppo applicazioni cloud-native su Oracle APEX e OCI.",  "status": "PUBLISHED",  "image": "https://api.radicle.services/orf/profile/123/photo"   `

4\. Sezioni strutturate
-----------------------

### 4.1. workExperience\[\]

Mappa orf\_experience.

Per ogni esperienza:

*   id: urn:orf:exp:{id}
    
*   type: "WorkExperience"
    
*   employer: employer\_name
    
*   jobTitle: job\_title
    
*   startDate, endDate: formato YYYY-MM
    
*   description
    

Esempio:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   "workExperience": [    {      "id": "urn:orf:exp:1",      "type": "WorkExperience",      "employer": "Radicle",      "jobTitle": "Senior Developer",      "startDate": "2018-01",      "endDate": null,      "description": "Sviluppo soluzioni APEX e integrazioni Oracle."    }  ]   `

### 4.2. education\[\]

Mappa orf\_education.

Campi raccomandati:

*   id: urn:orf:edu:{id}
    
*   type: "LearningAchievement"
    
*   title: program\_title
    
*   awardingBody: institution
    
*   eqfLevel: eqf\_level (se disponibile)
    
*   startDate, endDate: YYYY-MM
    
*   description (facoltativo)
    

### 4.3. skills\[\]

Mappa orf\_profile\_skill + orf\_skill.

*   id: urn:orf:skill:{id}
    
*   type: "Skill"
    
*   preferredLabel: label
    
*   proficiencyLevel: da proficiency\_level
    
*   escoUri: da esco\_uri (facoltativo)
    

Esempio:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   "skills": [    {      "id": "urn:orf:skill:10",      "type": "Skill",      "preferredLabel": "Oracle APEX",      "proficiencyLevel": "expert"    }  ]   `

### 4.4. languages\[\]

Mappa orf\_language.

*   type: "LanguageSkill"
    
*   lang: lang\_code
    
*   proficiency: livello (es. CEFR)
    
*   isNative: "Y" / "N"
    

### 4.5. links\[\]

Mappa orf\_profile\_link.

*   type: "WebPage"
    
*   label
    
*   url
    

### 4.6. projects\[\]

Mappa orf\_project.

*   id: urn:orf:project:{id}
    
*   name
    
*   role
    
*   startDate, endDate
    
*   description
    

### 4.7. credentials\[\]

Mappa orf\_credential.

*   id: urn:orf:credential:{id}
    
*   type: es. "CERTIFICATION", "BADGE"
    
*   title
    
*   issuerName
    
*   issueDate, expiryDate (YYYY-MM-DD)
    

raw\_vc\_json (se presente) può contenere la VC completa, ma l’inclusione nel documento ORF è opzionale e demandata all’implementazione.

5\. Estensione a Verifiable Credentials
---------------------------------------

Per usare un documento ORF come **Verifiable Credential**:

*   aggiungere "VerifiableCredential" in type;
    
*   mantenere credentialSubject nella struttura definita;
    
*   aggiungere un oggetto proof conforme a W3C VC Data Model(tipo firma, metodo di verifica, timestamp).
    

La specifica ORF è progettata per essere compatibile con questa evoluzione, senza cambiare la struttura base.

6\. Versioning e stabilità
--------------------------

*   Il contesto https://radicle.services/openresume/context/v2 deve:
    
    *   mantenere stabili i mapping dei campi core,
        
    *   permettere l’aggiunta di nuovi campi come estensioni non breaking.
        
*   Cambiamenti breaking alla struttura JSON-LD:
    
    *   richiedono una nuova versione del contesto (es. v3),
        
    *   non devono invalidare i documenti basati su versioni precedenti senza esplicita migrazione.
        

### Riferimenti

*   Esempio JSON-LD: examples/openresume-sample.json
    
*   Duality View di riferimento: db/dual\_views/orf\_openresume\_v.sql
    

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML``   Salvalo così com’è come `docs/jsonld-spec.md` nel repo.  ::contentReference[oaicite:0]{index=0}   ``
