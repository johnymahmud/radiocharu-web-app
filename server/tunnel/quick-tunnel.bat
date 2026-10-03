@echo off
echo ==============================================================================
echo [Radio Charu] Starting Cloudflare Ephemeral Quick Tunnel...
echo Connecting to internal Icecast broadcast engine on port 8000
echo ==============================================================================
echo.
echo Look for the *.trycloudflare.com URL below:
echo You can test this URL on your mobile browser over cellular data!
echo Press Ctrl+C to stop the quick tunnel.
echo.

docker run --rm -it --network radiocharu_network cloudflare/cloudflared:latest tunnel --url http://icecast_engine:8000
