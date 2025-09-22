# syntax=docker/dockerfile:1
FROM python:3.11-slim

WORKDIR /app

# System deps (pandas/numpy/etc. often need these)
RUN apt-get update && apt-get install -y \
    gcc g++ make libpq-dev supervisor \
    && rm -rf /var/lib/apt/lists/*

# Better caching: install requirements first
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your app code
COPY app ./app
COPY controller ./controller
COPY agents ./agents
COPY utils ./utils
COPY models.py ./
COPY data ./data
COPY app_gradio.py ./
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose only the UI port (Gradio)
EXPOSE 7860

# Optional: healthcheck on Gradio UI
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD wget -qO- http://127.0.0.1:7860/ || exit 1

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
