# -----------------------------------------------------------------------------
# Build Image

FROM swift:6.3 as builder

WORKDIR /app

COPY . /app/

RUN cd generator && \
    swift package resolve && \
    swift build -c release && \
    ./generator/build/release/hyweene build --docker

# -----------------------------------------------------------------------------
# Final image

FROM nginx:alpine

COPY --from=builder /app/release/ /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]