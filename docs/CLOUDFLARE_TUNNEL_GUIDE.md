# Cloudflare Zero Trust Tunnel Integration Guide
# ক্লাউডফ্লেয়ার জিরো ট্রাস্ট টানেল সেটআপ গাইড

This guide provides step-by-step instructions (in English & বাংলা) on how to securely expose the **Radio Charu** Icecast broadcast engine to the global internet with free automated SSL certificates, zero router port forwarding, and complete ISP CGNAT bypass.

---

## 🌟 Why Cloudflare Zero Trust Tunnel? / কেন ক্লাউডফ্লেয়ার টানেল?
- **No Public/Static IP Needed (কোন রিয়েল আইপি লাগবে না)**: Works seamlessly over standard home broadband (bypasses ISP CGNAT).
- **Zero Port Forwarding (রাউটার পোর্ট ওপেন করার ঝামেলা নেই)**: No need to open port 8000 on your home Wi-Fi router.
- **Automated SSL/HTTPS (ফ্রি অটোমেটিক এসএসএল)**: Delivers high-speed, secure HTTPS audio streaming (`https://stream.yourdomain.com/live`).
- **Edge Caching & DDoS Shield (ক্লাউডফ্লেয়ার সিকিউরিটি)**: Protects your local broadcasting machine from cyber attacks and network overload.

---

## 🚀 Quick Option: Ephemeral Quick Tunnel (তাত্ক্ষণিক টেস্ট করার জন্য)

If you don't have a custom domain configured yet, you can launch an instant temporary tunnel:

1. Double-click or run:
   ```powershell
   .\server\tunnel\quick-tunnel.bat
   ```
   *(or `./server/tunnel/quick-tunnel.sh` on Linux/macOS)*
2. Look in the terminal output for your temporary URL:
   `https://random-subdomain.trycloudflare.com`
3. Test the stream on your mobile phone or browser:
   `https://random-subdomain.trycloudflare.com/live`
   `https://random-subdomain.trycloudflare.com/status-json.xsl`

---

## 🛠️ Production Option: Dedicated Named Tunnel (কাস্টম ডোমেইন দিয়ে পার্মানেন্ট সেটআপ)

Follow these 5 simple steps:

### Step 1: Open Cloudflare Zero Trust Dashboard
1. Go to [dash.cloudflare.com](https://dash.cloudflare.com) and log in.
2. In the left sidebar, click on **Zero Trust**.
3. (If first time, choose the **Free Plan** and set a team name).

### Step 2: Create a Cloudflare Tunnel
1. Inside the Zero Trust dashboard, navigate to **Networks** $\rightarrow$ **Tunnels** (অথবা **Access** $\rightarrow$ **Tunnels**).
2. Click the **Add a tunnel** button.
3. Select **Cloudflared** as the connector type and click **Next**.
4. Set the tunnel name: `radiocharu-tunnel` and click **Save tunnel**.

### Step 3: Copy Your Tunnel Secret Token
1. Under the **Install and run a connector** step, select the **Docker** tab.
2. You will see a command like:
   ```bash
   docker run cloudflare/cloudflared:latest tunnel --no-autoupdate run --token <YOUR_SECRET_TOKEN>
   ```
3. **Copy only the token string** (the long base64 string after `--token`).
4. Open [`server/.env`](file:///f:/Vibecoding/radiocharu-web-app/server/.env) and paste the token:
   ```env
   CLOUDFLARE_TUNNEL_TOKEN=eyJhIjoiYmMy...YOUR_ACTUAL_TOKEN...
   ```

### Step 4: Configure Public Hostname Routing
1. In the Cloudflare Tunnel setup wizard, click **Next** to proceed to the **Public Hostnames** tab.
2. Click **Add a public hostname**:
   - **Subdomain**: `stream` (or `radio`)
   - **Domain**: Select your configured domain (e.g., `yourdomain.com`)
   - **Path**: Leave empty
   - **Service Type**: `HTTP`
   - **URL / Hostname**: `icecast_engine:8000`  *(IMPORTANT: Do not use localhost; use `icecast_engine:8000` because both containers share the Docker network)*
3. Click **Save hostname**.

### Step 5: Start the 2-Container Stack
1. From the project root, launch both Icecast and Cloudflare Tunnel:
   ```powershell
   docker compose -f server/docker-compose.yml up -d
   ```
2. Verify both containers are running:
   ```powershell
   docker compose -f server/docker-compose.yml ps
   ```
   You should see:
   - `radiocharu_icecast` (Up healthy)
   - `radiocharu_tunnel` (Up)

3. Inspect tunnel logs:
   ```powershell
   docker compose -f server/docker-compose.yml logs -f tunnel_gateway
   ```

---

## 📱 Verification & Mobile Testing Checklist

Once your tunnel is running and you are broadcasting from BUTT or Mixxx:

1. Turn off Wi-Fi on your smartphone and enable **Mobile Cellular Data (4G/5G)**.
2. Open your mobile browser and navigate to:
   - Live stream: `https://stream.yourdomain.com/live`
   - Real-time status: `https://stream.yourdomain.com/status-json.xsl`
3. Verify that high-quality sound plays instantly with zero buffering.
