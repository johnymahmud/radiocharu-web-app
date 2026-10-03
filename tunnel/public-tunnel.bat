@echo off
echo ==============================================================================
echo [Radio Charu] Starting Instant Public TLS Tunnel for Icecast...
echo Forwarding port 8000 (radiocharu_icecast) to public HTTPS
echo ==============================================================================
echo.
echo Look for your public https://*.lhr.life URL below:
echo.

ssh -o StrictHostKeyChecking=no -R 80:localhost:8000 nokey@localhost.run
