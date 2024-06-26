#!/bin/bash

MODEL=dolphin-llama3:8b
ollama serve & (ollama pull $MODEL && false) || true