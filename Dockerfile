# Imagen base de MinIO
FROM minio/minio:latest AS minio

# Imagen base de Nginx
FROM nginx:alpine

# Copiar config de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar binario de MinIO desde la imagen oficial
COPY --from=minio /usr/bin/minio /usr/bin/minio

# Crear carpeta para datos
RUN mkdir -p /data

# Variables de entorno (se pueden sobrescribir en Render)
ENV MINIO_ROOT_USER=admin
ENV MINIO_ROOT_PASSWORD=admin123

# Script de arranque: MinIO en background + Nginx en foreground
CMD minio server /data --address ":9000" --console-address ":9090" & \
    sed -i "s/8080/${PORT}/g" /etc/nginx/nginx.conf && \
    nginx -g 'daemon off;'