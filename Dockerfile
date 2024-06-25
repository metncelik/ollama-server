FROM runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04

ENV PIP_PREFER_BINARY=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY . .

RUN curl -fsSL https://ollama.com/install.sh | sh

RUN export OLLAMA_HOST=0.0.0.0:8000

RUN ollama serve

EXPOSE 8000

RUN chmod +x /app/start.sh
CMD ["/app/start.sh"]

