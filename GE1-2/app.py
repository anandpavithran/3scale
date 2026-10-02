import os
import socket
from fastapi import FastAPI

app = FastAPI(title="OpenShift S2I Microservice")

@app.get("/")
def read_root():
    return {
        "status": "online",
        "message": "Serving from OpenShift S2I",
        "pod_name": socket.gethostname(),
        "namespace": os.getenv("POD_NAMESPACE", "default"),
        "version": os.getenv("APP_VERSION", "1.0.0"),
    }

@app.get("/healthz")
def health_check():
    """Liveness probe: confirms the process is alive."""
    return {"status": "alive"}

@app.get("/readyz")
def readiness_check():
    """Readiness probe: confirms the service is ready for traffic."""
    return {"status": "ready"}
