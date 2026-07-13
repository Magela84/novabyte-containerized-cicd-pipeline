# ============================================================
# Dockerfile — NovaByte Application
# Multi-stage build for smaller production image
# ============================================================

# Stage 1 — Build stage
# Install dependencies in a separate stage
FROM python:3.11-slim AS builder

WORKDIR /app

# Copy requirements first for better layer caching
# Docker only re-runs pip install if requirements.txt changes
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2 — Production stage
# Start fresh with clean image — no build tools included
FROM python:3.11-slim AS production

WORKDIR /app

# Copy installed packages from builder stage
COPY --from=builder /root/.local /root/.local

# Copy application code
COPY app.py .

# Make sure scripts in .local are usable
ENV PATH=/root/.local/bin:$PATH

# Set environment defaults
ENV ENVIRONMENT=production
ENV PORT=8080

# Expose the port the app runs on
EXPOSE 8080

# Health check — Container Apps uses this to verify app is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')"

# Run with gunicorn — production WSGI server
# Workers = number of parallel request handlers
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--timeout", "60", "app:app"]
