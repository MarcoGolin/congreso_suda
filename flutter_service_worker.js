'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "ec6741f984a646f7c6a049562cd2a76b",
"assets/AssetManifest.bin.json": "0a96cf304a672b2dd13e1263655e9ec9",
"assets/AssetManifest.json": "8784f8204d445ad97f8617acdde462e4",
"assets/assets/fonts/Montserrat-Bold.ttf": "ed86af2ed5bbaf879e9f2ec2e2eac929",
"assets/assets/fonts/Montserrat-ExtraBold.ttf": "9e07cac927a9b4d955e2138bf6136d6a",
"assets/assets/fonts/Montserrat-Regular.ttf": "5e077c15f6e1d334dd4e9be62b28ac75",
"assets/assets/fonts/Poppins-Bold.ttf": "08c20a487911694291bd8c5de41315ad",
"assets/assets/fonts/Poppins-SemiBoldItalic.ttf": "9841f3d906521f7479a5ba70612aa8c8",
"assets/assets/imagenes/fondo/congreso_fondo.jpg": "f87290eb1fdb52b4e635cc66d3220452",
"assets/assets/imagenes/fondo/fondo_inicio.jpg": "f4e4328fb05a4ce1a235c7a0a732b26f",
"assets/assets/imagenes/ligas_academicas/LACARDIUS-SDG.png": "25ddf11bd70e36977e8830af6fb977fd",
"assets/assets/imagenes/ligas_academicas/LACIS-SDG.png": "d1602eae184af297c74f2caac938c841",
"assets/assets/imagenes/ligas_academicas/LACMUS-%2520SDG.png": "b5411a8a69fc51442eae7d0355b408b1",
"assets/assets/imagenes/ligas_academicas/LADAUS-SDG.png": "6938b81c17f17ac327eac4a474b8fa95",
"assets/assets/imagenes/ligas_academicas/LADERMUS-SDG.png": "241c6337645a1fd00e3a551b27fe7449",
"assets/assets/imagenes/ligas_academicas/LADTOUS-SDG.png": "9e7113db73a17d70c185b6168f50b1b0",
"assets/assets/imagenes/ligas_academicas/LAEME-SDG.png": "f550d59c131a93d0af9406cc9c967fe7",
"assets/assets/imagenes/ligas_academicas/LAETUS-SDG.png": "6c725ff401ab0cbe29a56e57bbb031f2",
"assets/assets/imagenes/ligas_academicas/LAGOUS-SDG.png": "7ea080a24adfcc1e242e81dca49155be",
"assets/assets/imagenes/ligas_academicas/LAIIUS-SDG.png": "91014b69598d77a3b6981d049b6836ef",
"assets/assets/imagenes/ligas_academicas/LAMICROUS-SDG.png": "def7067d0ca5bbfee4ad55c74ef8af69",
"assets/assets/imagenes/ligas_academicas/LANEURUS-SDG.png": "785c30b1ea4f24d28d84a3cc04df668f",
"assets/assets/imagenes/ligas_academicas/LANTUS-SDG.png": "4fafc891c8e83ae355ad37aa80aa4b7a",
"assets/assets/imagenes/ligas_academicas/LAOH-US-SDG.png": "2d88434088ec4a27d778b51f565f97ba",
"assets/assets/imagenes/ligas_academicas/LAPED-US-SDG.png": "1f20ae8a014df32cbb38a7cf2bad6581",
"assets/assets/imagenes/ligas_academicas/LAPSUSS-SDG.png": "0d529326037a06747d64c1dceb0428b8",
"assets/assets/imagenes/ligas_academicas/LIGAME-SDG.png": "72de1cd8e5f0ae0c80e8f87a7320cead",
"assets/assets/imagenes/logo/logo_congreso.png": "09e9d9851bf6a93d763c663b0de85ed1",
"assets/assets/imagenes/logo/logo_congreso_blanco.png": "db0c2a45c8a0a03cf54254fd9a3a4d09",
"assets/assets/imagenes/logo/logo_congreso_largo.png": "1242d6fdfb9f6e1e07047449c48966bd",
"assets/assets/imagenes/logo/logo_congreso_largo_blanco.png": "d48a32d93c31e3d8afa14ddd086d6ad8",
"assets/assets/imagenes/logo/logo_congreso_solo.png": "d8a538d35b3dcbf6081ede9dd91c623b",
"assets/assets/imagenes/logo/suda_inv_logo_blanco.png": "69486a79c4fc7d4525760a3a056773a9",
"assets/assets/imagenes/logo/suda_inv_logo_largo.png": "dabb37cb3f8edc51bc6d8812914a5048",
"assets/assets/imagenes/logo/suda_inv_logo_largo_blanco.png": "ceb908afb49e630df48703485fe7640a",
"assets/assets/imagenes/logo/suda_logo.png": "c299628ec6986541595c8619b80236c7",
"assets/assets/imagenes/logo/suda_logo_blanco.png": "66da25e981d8d35c04f9380ad54ccaca",
"assets/assets/imagenes/logo/suda_logo_largo.png": "84b90ea3dccceadfb30a58b3be89ba55",
"assets/assets/imagenes/logo/suda_logo_largo_blanco.png": "6eb25c92cddb1b130247969ddb92db9b",
"assets/assets/imagenes/personas/imagen_medica.png": "7122c80baf079ebd1ca3f023735e7d6d",
"assets/FontManifest.json": "c9172499bed712f4f5db5724521ca3d5",
"assets/fonts/MaterialIcons-Regular.otf": "cb55b40d4eaf906464fddbdf441ff138",
"assets/NOTICES": "90ae673fe4433758a227f4085959c11e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "825e75415ebd366b740bb49659d7a5c6",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "8bf6daa7d138af3a66d9a32aa22a4c24",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "76cc19231bf6152cb34c530fb144329d",
"/": "76cc19231bf6152cb34c530fb144329d",
"main.dart.js": "b0da818b26ccc10052a7707f26c50d52",
"manifest.json": "bf6b0d4ad879d8c73ee58cb4c9b6d5e0",
"version.json": "072d50252139c857fcc187baff83140b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
