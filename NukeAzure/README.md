# Generating the Content Hash

To generate the SHA‑256 hash for your PowerShell script file,
run the following command in PowerShell (replace the file path accordingly):

```powershell
Get-FileHash -Algorithm SHA256 -Path "C:\Path\To\DeleteResourceGroupRunbook.ps1" | Select -ExpandProperty Hash
```

or in linux or mac

```bash
shasum -a 256 ./DeleteResourceGroupRunbook.ps1
```

or withouth the file name

```bash
shasum -a 256 ./DeleteResourceGroupRunbook.ps1 | awk '{ print $1 }'
```
