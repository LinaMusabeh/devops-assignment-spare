#!/usr/bin/env bash
set -euo pipefail

STACK_NAME="compose-stack"

# --- helpers ---------------------------------------------------------------

err() {
    echo "[ERROR] $*" >&2
}

info() {
    echo "[INFO] $*"
}

require_service() {
    if [[ -z "${1:-}" ]]; then
        err "You must specify a service name"
        exit 1
    fi
}

# --- commands --------------------------------------------------------------

up() {
    info "Starting stack..."
    docker compose up --build -d || {
        err "Failed to start stack"
        exit 1
    }
    info "Stack started"
}

down() {
    info "Stopping stack..."
    docker compose down || {
        err "Failed to stop stack"
        exit 1
    }
    info "Stack stopped"
}

status() {
    info "Service status:"
    docker compose ps --format '{{.Name}}\t{{.Status}}'
}

logs() {
    require_service "${1:-}"
    local svc="$1"

    info "Tailing logs for service: $svc"
    docker compose logs -f --tail=100 -t "$svc"
}

smoke() {
    info "Running smoke test..."

    if curl -sf http://localhost:8080/health >/dev/null; then
        info "API is healthy"
        exit 0
    else
        err "API health check failed"
        exit 1
    fi
}

# --- dispatcher ------------------------------------------------------------

case "${1:-}" in
    up) up ;;
    down) down ;;
    status) status ;;
    logs) logs "${2:-}" ;;
    smoke) smoke ;;
    *)
        err "Unknown command: ${1:-}"
        echo "Usage: $0 {up|down|status|logs <service>|smoke}"
        exit 1
        ;;
esac
