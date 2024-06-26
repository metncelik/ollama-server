#!/bin/bash

MODEL=dolphin-llama3:8b
ollama serve & (sleep 5 && ollama pull $MODEL && false) || true