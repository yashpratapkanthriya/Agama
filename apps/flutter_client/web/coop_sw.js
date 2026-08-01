// COOP/COEP Service Worker for flutter_rust_bridge SharedArrayBuffer support
// Injects Cross-Origin-Opener-Policy and Cross-Origin-Embedder-Policy headers
// so SharedArrayBuffer (required for WASM threads) works in Chrome.

self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', (event) => event.waitUntil(self.clients.claim()));

self.addEventListener('fetch', (event) => {
  event.respondWith(
    fetch(event.request).then((response) => {
      // Only add headers to same-origin responses to avoid CORS issues
      const url = new URL(event.request.url);
      if (url.origin !== self.location.origin) return response;

      const newHeaders = new Headers(response.headers);
      newHeaders.set('Cross-Origin-Opener-Policy', 'same-origin');
      newHeaders.set('Cross-Origin-Embedder-Policy', 'require-corp');
      return new Response(response.body, {
        status: response.status,
        statusText: response.statusText,
        headers: newHeaders,
      });
    }).catch(() => fetch(event.request))
  );
});
