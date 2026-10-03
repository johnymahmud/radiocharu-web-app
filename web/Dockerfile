# ==============================================================================
# Radio Charu - Listener Web App & RJ Admin Dashboard Nginx Image
# ==============================================================================
FROM nginx:alpine

LABEL maintainer="Radio Charu <dev@radiocharu.com>"
LABEL description="Ultra-lightweight static web server and reverse proxy for Radio Charu"

# Remove default Nginx welcome page
RUN rm -rf /usr/share/nginx/html/*

# Copy Nginx custom virtual host configuration
COPY web/nginx.conf /etc/nginx/conf.d/default.conf

# Copy Listener Web App and RJ Admin static assets
COPY web /usr/share/nginx/html

# Expose HTTP port
EXPOSE 80

# Run Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
