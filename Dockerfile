# ======================
# 1. Base Stage
# ======================
FROM python:3.12-slim AS base
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc curl git \
    && rm -rf /var/lib/apt/lists/*

# ======================
# 2. Builder Stage
# ======================
FROM base AS builder
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --prefix=/install -r requirements.txt

# ======================
# 3. Build Stage
# ======================
FROM builder AS build
COPY . .
# Optional: build commands like asset compilation
# RUN python build_assets.py

# ======================
# 4. Runtime Stage
# ======================
FROM python:3.12-slim AS runtime
WORKDIR /app
COPY --from=builder /install /usr/local
COPY --from=build /app /app
EXPOSE 8000
CMD ["python", "app.py"]
