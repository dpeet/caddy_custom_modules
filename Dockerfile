FROM caddy:builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-ratelimit \
    --with github.com/porech/caddy-maxmind-geolocation
    --with github.com/tailscale/caddy-tailscale

FROM caddy:2

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
