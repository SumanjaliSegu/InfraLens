FROM python:3.10-slim

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps first (layer-cached as long as requirements.txt unchanged)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Never bake real secrets into the image — pass OPENAI_API_KEY and
# INFRALENS_API_TOKEN at runtime via  docker run -e  or  --env-file .env
ENV PYTHONUNBUFFERED=1 \
    CHROMA_PERSIST_DIR=/app/chroma_db

# Expose FastAPI port
EXPOSE 8000

# Health check — hits the root endpoint
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/')"

CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000"]