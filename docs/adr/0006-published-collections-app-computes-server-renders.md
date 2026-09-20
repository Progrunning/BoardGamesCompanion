# Published collections: the app computes, the server only stores and renders

The website shows a user's **published collection** at an unlisted **share link**, with statistics. All statistics logic lives in the Flutter app (the statistics language in `CONTEXT.md` — competitive/co-op win rates, head-to-head, rival/nemesis/buddy), and we decided not to port it. A publish sends **both** the raw user-authored data (collection entries, playthroughs, players, scores) and a **statistics snapshot** the app has already computed. The server stores the raw data as the future source of truth for cloud backup and live sync, stores the snapshot as a derived cache, and the website renders the snapshot verbatim. The server never recomputes anything. Identity is a device-held **publish key** with no account: the key travels in the user's backup, and a publish from any device holding the key replaces the whole published collection (last writer wins).

## Status

accepted

## Considered options

- **Publish only a rendered view model** (rejected: cheapest for phase 1 but derived data is useless as a backup, so the follow-up live sync would need a second, incompatible ingest path).
- **Publish only raw data and compute statistics on the server** (rejected: requires re-implementing and then keeping in lock-step a statistics language that is defined and tested in Dart; every stats change would ship twice. Angular was chosen for the site precisely because it needs no domain logic when the numbers arrive precomputed).
- **Flutter web for the site**, to reuse the stats code (rejected: canvas rendering gives the marketing pages no crawlable text and a heavy first load, defeating the "official place on the map" goal. Reuse becomes moot once the app ships the numbers).
- **Real accounts (email / Apple / Google sign-in)** (deferred, not rejected: it is the honest answer once cloud backup exists, but it is the first sign-in screen the app has ever had. The publish key is shaped so an account can later adopt and re-key it).
- **Read collections live from BGG by username** (rejected: no ingest and no identity, but it shows nothing BGG's own page does not, so there is no reason to visit).

## Consequences

- **The statistics snapshot is a cache, never a record.** The web may lag the app until the user republishes; the page carries a "published N ago" stamp to make this honest. Nothing server-side may edit it.
- **User-authored data now exists off-device**, in the managed MongoDB cluster next to the catalogue cache (a separate database; the cluster is on a backed-up tier). Until now the app's only durable copy was a local zip. The privacy policy must say so before the first release.
- **The publish key must be in the backup zip.** Without an account there is no recovery path for a lost key; a reinstall that loses it orphans a share link forever.
- **Two identifiers, not one.** The share link carries a short public id; the publish key is a bearer secret sent only in headers. If the URL were the key, anyone holding a link could overwrite the collection.
- **Other people's names are private by default.** A published collection includes the owner's players; per-player statistics are withheld from the web unless the owner opts in, so a friend never acquires a public win rate they did not agree to.
- **Publishing is manual** (a Publish/Unpublish action) until live sync exists; Unpublish hard-deletes the server copy.
- **One backend process.** The new routes join the existing Search API under a more general name, sharing its blue-green deploy and key map. The frozen search contract is a promise about `/api/search` responses and the legacy key, not about the assembly name.
