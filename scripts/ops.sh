#!/bin/bash
up() {
    docker compose up --build
}
 
down() {
    docker compose down
}
 
status() {
    docker compose ps --format '{{.Name}}\t{{.Status}}'
}
 
logs() {
    docker compose logs -f --tail=100 -t  
}
 
smoke() {
    if curl -sf http://localhost:8080/health; then
        echo "API is healthy"
        exit 0
    else
        echo "API is NOT healthy"
        exit 1
    fi
}