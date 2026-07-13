# ============================================================
# app.py — NovaByte Sample Application
# Simple Flask web app to demonstrate containerized deployment
# ============================================================

import os
from flask import Flask, jsonify
from datetime import datetime

app = Flask(__name__)

# Read environment variables set by Container Apps
ENVIRONMENT = os.environ.get("ENVIRONMENT", "unknown")
PROJECT     = os.environ.get("PROJECT", "unknown")
VERSION     = os.environ.get("APP_VERSION", "1.0.0")

@app.route("/")
def home():
    return jsonify({
        "status":      "healthy",
        "application": "NovaByte SaaS Platform",
        "version":     VERSION,
        "environment": ENVIRONMENT,
        "project":     PROJECT,
        "timestamp":   datetime.utcnow().isoformat(),
        "message":     "Deployed via GitHub Actions CI/CD Pipeline"
    })

@app.route("/health")
def health():
    return jsonify({
        "status":    "healthy",
        "timestamp": datetime.utcnow().isoformat()
    }), 200

@app.route("/info")
def info():
    return jsonify({
        "app":         "NovaByte",
        "version":     VERSION,
        "environment": ENVIRONMENT,
        "deployed_by": "GitHub Actions",
        "registry":    "Azure Container Registry",
        "runtime":     "Azure Container Apps"
    })

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port, debug=False)
