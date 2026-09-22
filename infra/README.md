# infra

Azure infrastructure-as-code (Bicep). The devcontainer ships with the Azure CLI
and the Bicep CLI (`az bicep`) preinstalled.

- `main.bicep` — entry point; add modules under `infra/modules/` as the deployment grows.

Typical workflow:

```bash
az bicep build --file infra/main.bicep
az deployment group what-if --resource-group <rg> --template-file infra/main.bicep --parameters @infra/main.parameters.json
az deployment group create --resource-group <rg> --template-file infra/main.bicep --parameters @infra/main.parameters.json
```
