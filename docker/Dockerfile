# -----------------------------------------------------------------------------
# Build Image

FROM swift:6.3 AS builder

WORKDIR /app

COPY . /app/

RUN cd generator && \
    swift package resolve && \
    swift build -c release && \
    cd .. && \
    ./generator/.build/release/hyweene build --docker

# -----------------------------------------------------------------------------
# Final image

FROM nginx:alpine AS final

COPY --from=builder /app/current/ /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]