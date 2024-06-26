FROM runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04

ENV PIP_PREFER_BINARY=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY ./src .

RUN curl -fsSL https://ollama.com/install.sh | sh

ARG MODEL \
    MODELFILE
ENV MODEL=${MODEL} \
    MODELFILE=${MODELFILE}

RUN echo ${MODELFILE} > "Modelfile"

#download & create model
RUN ollama serve & \
    (sleep 5 && \
    ollama pull ${MODEL} &&  \
    ollama create custom-${MODEL} && false) \
    || true

EXPOSE 8000

RUN chmod +x start.sh
CMD ["./start.sh"]