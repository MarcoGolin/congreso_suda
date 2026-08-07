/**
 * Congreso UNISUD - Custom Service Worker
 * Flutter 3.41+ deprecó el SW built-in — este es el nuestro.
 *
 * BUILD_NUMBER_PLACEHOLDER es sustituido por post_build_web en cada build.
 * Si no se sustituye, usa 'dev' (útil para desarrollo local).
 */
const CACHE_VERSION = 'BUILD_NUMBER_PLACEHOLDER';
const IMMUTABLE_CACHE = 'congreso-immutable-v' + CACHE_VERSION;
const APP_CACHE = 'congreso-app-v' + CACHE_VERSION;
const ALL_CACHES = [IMMUTABLE_CACHE, APP_CACHE];

// Patrones de assets inmutables entre builds (cache-first)
const IMMUTABLE_PATTERNS = [
  /\.wasm$/,
  /canvaskit\//,
  /skwasm/,
  /\.woff2?$/,
  /\.ttf$/,
  /\.otf$/,
  /\/assets\//,
  /\.png$/,
  /\.jpg$/,
  /\.jpeg$/,
  /\.webp$/,
  /\.svg$/,
  /\.ico$/,
];

// Estos nunca deben ser interceptados — siempre van a la red
const NETWORK_ONLY_PATTERNS = [
  /index\.html/,
  /flutter_bootstrap\.js/,
  /flutter_service_worker\.js/,
  /version\.json/,
  /manifest\.json/,
  /\?/,  // cualquier URL con query params (incluyendo cache-bust requests)
];

// =====================
// Ciclo de vida del SW
// =====================

self.addEventListener('install', () => {
  // Activa inmediatamente sin esperar a que las pestañas existentes se cierren
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys()
      .then(names => Promise.all(
        names
          .filter(name => !ALL_CACHES.includes(name))
          .map(name => {
            console.log('[Congreso SW] Removiendo cache antiguo:', name);
            return caches.delete(name);
          })
      ))
      .then(() => {
        console.log('[Congreso SW] Activado, versión:', CACHE_VERSION);
        // Toma control de todas las pestañas abiertas inmediatamente
        return self.clients.claim();
      })
  );
});

// =====================
// Estrategia de fetch
// =====================

self.addEventListener('fetch', event => {
  const request = event.request;
  const url = new URL(request.url);

  // Sólo interceptar requests GET del mismo origen
  if (request.method !== 'GET') return;
  if (url.origin !== self.location.origin) return;

  const path = url.pathname;

  // Network-only: archivos críticos que siempre deben ser frescos
  if (NETWORK_ONLY_PATTERNS.some(p => p.test(path + url.search))) return;

  // Cache-first: assets inmutables (WASM, fuentes, imágenes, etc.)
  if (IMMUTABLE_PATTERNS.some(p => p.test(path))) {
    event.respondWith(cacheFirst(request, IMMUTABLE_CACHE));
    return;
  }

  // Cache-first: código de la app (main.dart.js y otros .js)
  // Seguro porque CACHE_VERSION cambia en cada build → activate() limpia caches antiguos.
  // El poller de version.json + applyUpdate() garantizan que las actualizaciones se apliquen.
  if (path.endsWith('.js') || path.endsWith('.dart')) {
    event.respondWith(cacheFirst(request, APP_CACHE));
    return;
  }
});

// =====================
// Estrategias de cache
// =====================

async function cacheFirst(request, cacheName) {
  const cached = await caches.match(request);
  if (cached) return cached;

  try {
    const response = await fetch(request);
    if (response.ok) {
      const cache = await caches.open(cacheName);
      cache.put(request, response.clone());
    }
    return response;
  } catch (err) {
    console.warn('[Congreso SW] cache-first fetch falló:', request.url, err);
    throw err;
  }
}
