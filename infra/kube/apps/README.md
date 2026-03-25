CRDs > openbao + unseal + init + bootstrap + seed > external secrets operator + cert-manager > registry > dev-db + init > gitea 
Hooks and resources are assigned to wave zero by default. The wave can be negative, so you can create a wave that runs before all other resources.
- CRDs 
- OpenBao deployment + unseal + init + bootstrap + seed
- External Secrets Operator, 
- cert-manager (now can read from Bao)
- Registry (its secret can now be fulfilled by ESO)
- tekton
- tailscale
- dev-tools db
- Init jobs (init-dbs, etc.)
- Application layer (mana)
