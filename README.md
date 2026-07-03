# michiganweb

`michigan.acestus.com` — Michigan trip vacation info page (August 12–19, 2026,
Oscoda, MI).

Static Vite + TypeScript site deployed to an Azure Static Web App (Free SKU),
mirroring the [acewatch](https://github.com/Acestus/acewatch) reference
architecture minus the API/storage backend — this site has no dynamic data.

## Structure

```
/
├── infra/
│   ├── main.bicep              Single Microsoft.Web/staticSites (Free SKU) + optional custom domain
│   └── dev/main.dev.bicepparam Dev environment parameters (only environment — no stg/prd)
├── .github/workflows/
│   └── deploy-azure.yaml       OIDC azure/login + Bicep deploy + Vite build + SWA upload
└── src/Web/
    ├── index.html              Page content
    ├── src/main.ts             Minimal client-side script (last-updated stamp)
    ├── src/style.css
    └── public/images/          Trip photos (empty for now)
```

## Local development

```bash
cd src/Web
npm install
npm run dev
```

## Deploying

1. **Azure setup (one-time):**
   - Create resource group `rg-michiganweb`.
   - Create an Azure AD app registration dedicated to this repo, with a
     federated credential for GitHub Actions OIDC (`repo:Acestus/michiganweb:ref:refs/heads/main`,
     or scoped to `workflow_dispatch` as needed).
   - Add repo secrets: `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`.

2. **Run the deploy workflow** (`Actions` → `Deploy Azure` → `Run workflow`):
   - `resource_group`: `rg-michiganweb`
   - `location`: `westus2`
   - `static_web_app_name`: `swa-michiganweb-dev-001`

   This provisions the Bicep template (Free SKU SWA), builds the Vite site,
   and uploads it via `Azure/static-web-apps-deploy@v1`.

3. **Custom domain (michigan.acestus.com):**
   - At Hover, add a `CNAME` record: `michigan` → `<swa-default-hostname>.azurestaticapps.net`.
   - Once the CNAME resolves, the `customDomain` resource in `main.bicep`
     (already parameterized with `michigan.acestus.com`) validates and Azure
     issues the managed certificate automatically.

## Notes

- No backend, no Functions, no Storage — content is fully static.
- Photos are not yet added; `public/images/` and the gallery section in
  `index.html` are placeholders until photos are available.
