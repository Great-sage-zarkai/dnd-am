const CACHE = 'dnd-dr-v4';
const ASSETS = [
  './preview.html', './view.html', './manifest.json',
  '../icon.png', '../logo.png',
  '../icons/druid.png', '../icons/bear.png', '../icons/storm.png',
  '../icons/d20.png', '../icons/moon.png', '../icons/sun.png',
  '../icons/basic.png', '../icons/stats.png', '../icons/classf.png',
  '../icons/feats.png', '../icons/notes.png', '../icons/saved.png',
  '../icons/lore.png', '../icons/bonfire.png', '../icons/hacker.png',
  '../icons/necromancer.png', '../icons/skeleton.png', '../icons/shadow.png',
  '../icons/crystal-ball.png', '../icons/spellbook.png', '../icons/potion.png',
  '../icons/thunderbolt.png', '../icons/wooden-stick.png', '../icons/zzz.png',
  '../icons/bow-and-arrow.png', '../icons/speed.png', '../icons/slash.png',
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
