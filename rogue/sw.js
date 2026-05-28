const CACHE = 'dnd-rg-v7';
const ASSETS = [
  './preview.html', './manifest.json',
  '../icon.png', '../logo.png',
  '../icons/rogue.png', '../icons/d20.png', '../icons/slash.png',
  '../icons/basic.png', '../icons/stats.png', '../icons/classf.png',
  '../icons/necromancer.png', '../icons/feats.png', '../icons/notes.png',
  '../icons/dagger.png', '../icons/hacker.png', '../icons/speed.png',
  '../icons/skeleton.png', '../icons/shadow.png',
  '../icons/bonfire.png', '../icons/moon.png', '../icons/sun.png',
  '../icons/sword.png', '../icons/bard.png',
  '../icons/crystal-ball.png', '../icons/bow-and-arrow.png',
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
