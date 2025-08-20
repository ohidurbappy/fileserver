# Build stage
FROM golang:1.24-alpine AS builder

# Set working directory
WORKDIR /app

# Copy go mod files
COPY go.mod go.sum* ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o fileserver .

# Final stage
FROM alpine:latest

# Install ca-certificates for HTTPS requests (if needed)
RUN apk --no-cache add ca-certificates

# Create non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy the binary from builder stage
COPY --from=builder /app/fileserver .

# Create uploads directory and set permissions
RUN mkdir -p /app/uploads && \
    chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 3000

# Set default environment variables
ENV UPLOAD_DIR=/app/uploads
ENV PORT=3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT}/uploads/ || exit 1

# Run the application
CMD ["./fileserver"]
