# powerautomate

Power Automate flow definitions used to connect this project to Microsoft 365 /
Dynamics touchpoints (e.g. routing extracted deal data, triggering approvals).

- `flows/` — exported flow definitions (`.json`), one subfolder per flow, as
  produced by "Export as package" in Power Automate.

These are configuration exports, not application code: keep them in sync with
what's deployed by re-exporting after changes made in the Power Automate designer.
