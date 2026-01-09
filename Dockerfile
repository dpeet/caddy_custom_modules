FROM caddy:builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-ratelimit \
    --with github.com/porech/caddy-maxmind-geolocation \
    --with github.com/tailscale/caddy-tailscale \
    --with github.com/WeidiDeng/caddy-cloudflare-ip
    --with github.com/caddyserver/transform-encoder \
	--with github.com/hslatman/caddy-crowdsec-bouncer/http@main \
	--with github.com/hslatman/caddy-crowdsec-bouncer/appsec@main \
	--with github.com/hslatman/caddy-crowdsec-bouncer/layer4@main

FROM caddy:2

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
