#!/bin/bash

# 0. Troubleshoting(optional)
#sudo groupadd docker
#sudo usermod -aG docker $USER
#newgrp docker

# 1. Create directory
SETUP_DIR="setup"
if [ ! -d "$SETUP_DIR" ]; then
    mkdir -p "$SETUP_DIR"
    echo "✅ Created directory: $SETUP_DIR"
else
    echo "ℹ️  Directory already exists: $SETUP_DIR"
fi

# 2. Download files
download_file() {
    local url="$1"
    local filename="$2"
    
    if [ ! -f "$SETUP_DIR/$filename" ]; then
        echo "⬇️  Downloading $filename..."
        curl -so "$SETUP_DIR/$filename" "$url"
        
        if [ $? -eq 0 ]; then
            echo "✅ Successfully downloaded: $filename"
        else
            echo "❌ Failed to download: $filename"
            exit 1
        fi
    else
        echo "ℹ️  File already exists (skipping download): $filename"
    fi
}
download_file "https://get.openziti.io/dock/docker-compose.yml" "docker-compose.yaml"
download_file "https://get.openziti.io/dock/.env" ".env"

echo "✔️ File setup completed!"

# 3. Start Docker containers
echo "🚀 Starting Docker containers..."
(cd "$SETUP_DIR" && docker compose --project-name docker up -d)

if [ $? -eq 0 ]; then
    echo "✅ Docker containers started successfully"
    (cd "$SETUP_DIR" && docker compose -p docker ps)
else
    echo "❌ Failed to start Docker containers"
    exit 1
fi

#4 show docker names and useful codes
echo ""
echo "✅OpenZiti Docker setup complete!"
echo "You can access the controller with the default credentials from the .env file"
echo "To view logs, run: docker compose logs -f"
echo "To stop the containers, run: cd "$SETUP_DIR" && docker compose down && cd ../" 
