# ceos-certs

playground to test cert rollout

> WARNING: this is a early, not optimized version!

1. Set you Arista token as secret called ARTOKEN in `Settings > Secrets and variables > Codespaces > New repository secret`
2. Click `Code > Codespaces > Create codespace on master`
3. Start containerlab with `make start`. Use `make stop` any time to stop it.
4. Deploy certificates with `ansible-playbook playbooks/ava_from_local.yml`

> NOTE: there is also `generate_certs_onbox.yml` that can replace local cert generation part if required.
