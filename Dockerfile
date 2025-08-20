# Build stage
FROM golang:1.24-alpine AS builder
WORKDIR /app

# Copy and download dependencies
COPY go.mod ./
RUN go mod download

# Copy source
COPY . .

# Build binary (optimized)
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -trimpath -o fileserver .

# Final stage
FROM scratch

# Copy binary and certs
COPY --from=builder /app/fileserver /fileserver
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Non-root user
USER 1001

# Expose port
EXPOSE 3000

# Environment
ENV UPLOAD_DIR=/app/uploads
ENV PORT=3000

# Healthcheck
HEALTHCHECK CMD [ "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/uploads/" ]

# Run
ENTRYPOINT ["/fileserver"]
