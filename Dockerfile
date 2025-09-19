# ======================
# 1. Builder Stage
# ======================
FROM python:3.10-slim AS builder

# Set working directory
WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (to leverage Docker cache)
COPY requirements.txt .

# Install dependencies into a folder
RUN pip install --upgrade pip \
    && pip install --prefix=/install -r requirements.txt


# ======================
# 2. Final Runtime Stage
# ======================
FROM python:3.10-slim

WORKDIR /app

# Copy installed dependencies from builder
COPY --from=builder /install /usr/local

# Copy application code
COPY . .

# Expose port (change if needed)
EXPOSE 8000

# Default command (you can replace with uvicorn/flask/etc.)
CMD ["python", "app.py"]
