"""
Cloud-Native API Administration Lab Application
Framework: Flask
Runtime: Red Hat UBI 9 Minimal (Python 3.14)
"""

import os
from flask import Flask, jsonify, request

app = Flask(__name__)

# Sample in-memory catalog data
PRODUCTS = [
    {
        "id": 1,
        "name": "Standard Subscription",
        "quota": 1000,
        "status": "active"
    },
    {
        "id": 2,
        "name": "Enterprise Subscription",
        "quota": 50000,
        "status": "active"
    }
]


@app.route("/", methods=["GET"])
def root():
    """Root health check endpoint."""
    return jsonify(
        {
            "service": "account-backend-api",
            "status": "UP",
            "version": "1.0.0",
            "environment": os.getenv("APP_ENV", "production")
        }
    ), 200


@app.route("/healthz", methods=["GET"])
def healthz():
    """Liveness probe endpoint for OpenShift."""
    return jsonify({"status": "healthy"}), 200


@app.route("/api/v1/accounts", methods=["GET"])
def list_accounts():
    """
    Returns account details.
    Mapped to 3scale Product / Backend method: list_accounts
    """
    return jsonify(
        {
            "success": True,
            "count": len(PRODUCTS),
            "data": PRODUCTS
        }
    ), 200


@app.route("/api/v1/accounts/<int:account_id>", methods=["GET"])
def get_account(account_id):
    """
    Returns a single account by ID.
    Mapped to 3scale Product / Backend method: get_account
    """
    item = next((p for p in PRODUCTS if p["id"] == account_id), None)
    if not item:
        return jsonify(
            {
                "success": False,
                "error": "Account not found"
            }
        ), 404

    return jsonify(
        {
            "success": True,
            "data": item
        }
    ), 200


@app.route("/api/v1/accounts", methods=["POST"])
def create_account():
    """
    Creates a new account.
    Mapped to 3scale Product / Backend method: create_account
    """
    payload = request.get_json(silent=True)
    if not payload or "name" not in payload:
        return jsonify(
            {
                "success": False,
                "error": "Invalid request body. 'name' is required."
            }
        ), 400

    new_entry = {
        "id": len(PRODUCTS) + 1,
        "name": payload.get("name"),
        "quota": payload.get("quota", 500),
        "status": payload.get("status", "pending")
    }
    PRODUCTS.append(new_entry)

    return jsonify(
        {
            "success": True,
            "message": "Account created successfully",
            "data": new_entry
        }
    ), 201


if __name__ == "__main__":
    # Runs on port 8080 as non-root user in Red Hat UBI container
    port = int(os.getenv("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
