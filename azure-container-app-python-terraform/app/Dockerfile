# syntax=docker/dockerfile:1

FROM python:3.12-slim

# OS deps
RUN apt-get update && apt-get install -y --no-install-recommends \    curl ca-certificates && \    rm -rf /var/lib/apt/lists/*

# Add non-root user
RUN useradd -ms /bin/bash appuser

WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY src /app/app
ENV PYTHONUNBUFFERED=1
ENV PORT=8000

EXPOSE 8000
USER appuser

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
