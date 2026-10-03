// Radio Charu - Service Worker (PWA Shell & Cache Manager)
const CACHE_NAME = 'radiocharu-v2-white-ui';
const STATIC_ASSETS = [
  './',
  './index.html',
  './css/style.css?v=2.1.0',
  './js/config.js?v=2.1.0',
  './js/audio-player.js?v=2.1.0',
  './js/telemetry.js?v=2.1.0',
  './js/app.js?v=2.1.0',
  './manifest.json',
  './icons/logo.svg'
];

// Install Event: Cache app shell
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('[Service Worker] Caching app shell...');
      return cache.addAll(STATIC_ASSETS);
    }).then(() => self.skipWaiting())
  );
});

// Activate Event: Clean up all legacy caches immediately
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) {
            console.log('[Service Worker] Removing old cache:', key);
            return caches.delete(key);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch Event: Network-only for Admin & Streams; Network-first for dynamic live streams & telemetry
self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);

  // 1. Completely bypass Service Worker cache for /admin routes (Network-Only Policy)
  if (url.pathname.includes('/admin')) {
    return event.respondWith(fetch(event.request));
  }

  // 2. Bypass cache completely for live audio streams & status telemetry
  if (
    url.pathname.endsWith('/live') ||
    url.pathname.includes('status-json') ||
    url.pathname.includes('status.xsl') ||
    event.request.destination === 'audio'
  ) {
    return event.respondWith(fetch(event.request));
  }

  // 3. Cache-first falling back to network for public listener app assets
  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      if (cachedResponse) {
        return cachedResponse;
      }
      return fetch(event.request).then((networkResponse) => {
        // Cache newly requested same-origin resources (strictly excluding /admin)
        if (
          networkResponse &&
          networkResponse.status === 200 &&
          event.request.method === 'GET' &&
          url.origin === location.origin &&
          !url.pathname.includes('/admin')
        ) {
          const responseToCache = networkResponse.clone();
          caches.open(CACHE_NAME).then((cache) => {
            cache.put(event.request, responseToCache);
          });
        }
        return networkResponse;
      }).catch(() => {
        if (event.request.mode === 'navigate') {
          return caches.match('./index.html');
        }
      });
    })
  );
});
