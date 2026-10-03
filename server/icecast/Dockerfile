# ==============================================================================
# Radio Charu - Production-Grade Icecast2 Audio Engine Container
# ==============================================================================
FROM alpine:3.20

# Install Icecast2, mime types, and su-exec for safe rootless runtime execution
RUN apk add --no-cache \
    icecast \
    mailcap \
    su-exec \
    curl \
    ca-certificates \
    && mkdir -p /var/log/icecast2 /etc/icecast2 \
    && ln -s /usr/share/icecast /usr/share/icecast2 2>/dev/null || true \
    && chown -R icecast:icecast /var/log/icecast2 /etc/icecast2 /usr/share/icecast

# Copy entrypoint script and default config
COPY entrypoint.sh /entrypoint.sh
COPY icecast.xml /etc/icecast2/icecast.xml

RUN chmod +x /entrypoint.sh \
    && chown icecast:icecast /etc/icecast2/icecast.xml

# Expose Icecast2 default broadcasting port
EXPOSE 8000

# Health check to ensure status JSON is responding
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/status-json.xsl || exit 1

ENTRYPOINT ["/entrypoint.sh"]
