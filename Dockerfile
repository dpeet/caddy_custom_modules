FROM caddy:builder AS builder

# Pin core to v2.11.7: 2.11.6 cuts long-lived streams at its 1m idle timeouts (caddy #8103/#8118)
# and caddy:builder still ships 2.11.6. Drop the version argument once caddy:builder >= 2.11.7.
# See peet_homeautomation docs/todo/caddy-2-11-6-edge-review.md (D1b).
RUN xcaddy build v2.11.7 \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-ratelimit \
    --with github.com/porech/caddy-maxmind-geolocation \
    --with github.com/tailscale/caddy-tailscale \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/caddyserver/transform-encoder \
	# crowdsec-bouncer pinned to the commit production ran when pinned (2026-10-05; was @main, so
	# every nightly build could silently pull new bouncer code). Bump deliberately: pick a newer
	# commit or release tag, then let CI's required-modules check vet the build.
	--with github.com/hslatman/caddy-crowdsec-bouncer/http@ffdcb7c6f861 \
	--with github.com/hslatman/caddy-crowdsec-bouncer/appsec@ffdcb7c6f861 \
	--with github.com/hslatman/caddy-crowdsec-bouncer/layer4@ffdcb7c6f861

FROM caddy:2

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
