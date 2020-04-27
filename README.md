# web_healthcheck

This is a very simple tool to respond to HTTP calls.
You give it a path and a payload and it will respond to that.

```text
  -address string
        IP address to listen on. (default "0.0.0.0")
  -cert string
        TLS certificate.
  -h    Shows help menu.
  -key string
        TLS private key.
  -path string
        Path to respond on (default "/_status")
  -port int
        TCP port for HTTP(S) Server (default 8080)
  -response string
        JSON payload for the response (default "{\"healthy\":true}")
  -v    Shows the version.
```
