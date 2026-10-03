# scriptv2 — VLESS-WS, Slim Variant (Cloud Run)

A slimmer take on the [`script`](../script) VLESS service: Xray only, no Python
dashboard. Use `script` if you want the status dashboard; use this if you want
the smallest possible image.

```
client ──TLS──> :$PORT ──> xray (vless inbound, /etc/xray/config.json)
```

## Files

| File | Purpose |
|---|---|
| `Dockerfile` | `teddysun/xray` base; copies config + entrypoint |
| `config.json` | Xray inbounds (vless on `$PORT`, internal http) |
| `entrypoint.sh` | Rewrites `8080` → `$PORT` in the config, then `exec xray` |
| `deploy.sh` | Interactive GCP deployer |
| `network-monitor.sh` | Traffic monitor helper |
| `.github/workflows/docker-build.yml` | CI: multi-arch build & push to GHCR |

## Deploy

```bash
chmod +x deploy.sh
./deploy.sh
```

## Notes

- The second (http) inbound on fixed port 8081 is internal-only; Cloud Run only
  routes `$PORT`. It is harmless but serves no traffic in this setup.
