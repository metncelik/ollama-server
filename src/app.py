import time
import runpod
import requests
from requests.adapters import HTTPAdapter, Retry
from dotenv import load_dotenv
import os

load_dotenv()

MODEL = os.getenv("MODEL")
OLLAMA_BASE = "http://127.0.0.1:11434"

req_client = requests.Session()
retries = Retry(total=3, backoff_factor=0.1, status_forcelist=[502, 503, 504])
req_client.mount('http://', HTTPAdapter(max_retries=retries))

def wait_for_service(url):
    while True:
        try:
            response = requests.get(url)
            break
        except requests.exceptions.RequestException:
            print("Service not ready yet. Retrying...")
        except Exception as err:
            print("Error: ", err)
        time.sleep(0.5)


def run_inference(params):
    body = {
    "model": f"custom-{MODEL}",
    "stream": params.pop("stream", False),
    "messages": params.pop("messages")
    }
    
    response = req_client.post(
        f"{OLLAMA_BASE}/api/chat",
        json=body,
        timeout=200
    )
    
    if response.status_code == 200:
        return response.json()
    

def handler(event):
    json = run_inference(event["input"])
    return json


if __name__ == "__main__":
    wait_for_service(url=OLLAMA_BASE)
    runpod.serverless.start({"handler": handler})