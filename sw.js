const CACHE = 'dnd-am-v13';
const ASSETS = [
  './preview.html', './view.html', './manifest.json', './icon.png', './logo.png',
  './icons/char.png', './icons/spells.png', './icons/tracker.png', './icons/build.png',
  './icons/saved.png', './icons/basic.png', './icons/stats.png', './icons/lore.png',
  './icons/classf.png', './icons/subclass.png', './icons/feats.png', './icons/notes.png',
  './icons/hp.png', './icons/slots.png', './icons/shortrest.png', './icons/longrest.png',
  './icons/tip.png', './icons/buildmode.png', './icons/nospells.png',
  './icons/sun.png'
];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(ASSETS)));
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.matchAll({ type: 'window' }))
      .then(clients => clients.forEach(c => c.postMessage({ type: 'SW_UPDATED' })))
  );
  self.clients.claim();
});

self.addEventListener('fetch', e => {
  e.respondWith(
    caches.match(e.request).then(r => r || fetch(e.request).then(res => {
      if (res && res.status === 200) {
        const clone = res.clone();
        caches.open(CACHE).then(c => c.put(e.request, clone));
      }
      return res;
    }))
  );
});
