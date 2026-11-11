# QML + OSM: Loading Offline Tiles from Local Drive

- **Question:** [stackoverflow.com/q/79711085](https://stackoverflow.com/questions/79711085/qml-osm-loading-offline-tiles-from-local-drive) by [Marco](https://stackoverflow.com/users/25704711/marco) · July 2025
- **Tags:** `qt` `dictionary` `qml` `openstreetmap`
- **My answer:** [answer 79711712](https://stackoverflow.com/questions/79711085/qml-osm-loading-offline-tiles-from-local-drive/79711712#79711712) · score 0 · July 2025

## Question

The asker sets the OSM plugin's `osm.mapping.offline.directory` to a local folder of
tiles, but the map always loads online tiles. They checked this by marking a local tile
and disconnecting from the internet. Several directory layouts did not help, including
the one from the Qt blog post on offline tiles.

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/79711085/qml-osm-loading-offline-tiles-from-local-drive).

## My answer

I've used the [demo](https://www.qt.io/blog/2017/05/24/qtlocation-using-offline-map-tiles-openstreetmap-plugin) from this blog post you've shared, rewrote it to use CMake and updated it to Qt 6.8. For me it works. In `zoomLevel` 1 and 2 it shows the offline tiles. When zooming further in it starts using online tiles.
My guess is that this is the problem you're encountering, because your code starts with a `zoomLevel: 15`.  You need to provide the offline tiles for all the available zoom levels otherwise it tries to fetch tiles online.
Have a look at the rewritten [demo](https://github.com/iam-peter/stackoverflow/tree/main/questions/79711085).

I've tried to generate tiles with a python script for more than 3 zoom levels and it seems that the offline loading capability has a hard zoom limit. No matter how many offline zoom level tiles are provided, zoom level 3 always starts to fetch online tiles.

This feature description from the blog post might hint towards a hard limit:

> The intended use cases that this feature aims to address are mainly:
> - shipping custom maps for limited regions with the application.
> - **shipping tiles for low zoom levels with the application so to prevent blank maps when the application is run for the first time without internet connection.**

## Code in this folder

The offline tiles demo from the Qt blog post, ported to CMake and Qt 6.8. Tiles for zoom
levels 0 to 2 are embedded as resources under `:/offline_tiles/`. Use the mouse wheel to
zoom. From zoom level 3 on, the map fetches tiles online. `main.cpp` and `Main.qml` are
derived from the Qt example and keep its BSD license header.

| File | Contents |
| --- | --- |
| [`CMakeLists.txt`](CMakeLists.txt) | CMake project |
| [`main.cpp`](main.cpp) | Application entry point |
| [`Main.qml`](Main.qml) | `Map` with the `osm.mapping.offline.directory` parameter and wheel zoom |
| [`offline_tiles/`](offline_tiles/) | Tiles named `osm_100-l-<map id>-<z>-<x>-<y>.png` |

### Build and run

Requires Qt 6.8 or later with these modules: Qt Quick, Qt Location.

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/gcc_64
cmake --build build
./build/appDemo79711085
```
