# Use official Nginx image as base
FROM nginx:alpine

# Install curl for healthcheck
RUN apk add --no-cache curl

# Create necessary directories
RUN mkdir -p /var/log/nginx

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy application files
COPY templates/ /usr/share/nginx/html/
COPY static/ /usr/share/nginx/html/static/

# Set proper permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"] 