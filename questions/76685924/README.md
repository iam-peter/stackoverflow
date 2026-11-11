# How to change map.activeMapType at the app startup?

- **Question:** [stackoverflow.com/q/76685924](https://stackoverflow.com/questions/76685924/how-to-change-map-activemaptype-at-the-app-startup) by [kancler](https://stackoverflow.com/users/18823391/kancler) · July 2023
- **Tags:** `qt` `qml` `qtlocation`
- **My answer:** [answer 76686893](https://stackoverflow.com/questions/76685924/how-to-change-map-activemaptype-at-the-app-startup/76686893#76686893) · accepted · score 2 · July 2023

## Question

The asker wants the map to start with "Terrain Map" active. Triggering the matching menu
action from `MapView`'s `Component.onCompleted` takes effect, but the map then
switches back to the default street map. Only a short `Timer` works, and they ask for
a cleaner solution.

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/76685924/how-to-change-map-activemaptype-at-the-app-startup).

## My answer

As already written in the comments on your question the issue is

```text
QGeoTileProviderOsm: Tileserver disabled at  QUrl("http://maps-redirect.qt.io/osm/5.8/satellite")
QGeoTileFetcherOsm: all providers resolved
```

which basically re-generates the [`supportedMapTypes`][1] and thus resetting the [`activeMapType`][2], so all previous set map types are overwritten.

I found a solution for it [here][3]. This will add `PluginParameter` objects to the `Plugin` object in order to avoid the re-generation of the available providers. You can read more about this [here][4] (also linked in the forum post).

```qml
ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Map")

    property int activeMapTypeIndex: 0
    property string startupMapTypeName: "Terrain Map"

    onActiveMapTypeIndexChanged: {
        mapView.map.activeMapType = mapView.map.supportedMapTypes[root.activeMapTypeIndex]
    }

    Component.onCompleted: {
        let supportedMapTypes = mapView.map.supportedMapTypes

        for (let i = 0; i < supportedMapTypes.length; ++i) {
            if (supportedMapTypes[i].name === root.startupMapTypeName) {
                root.activeMapTypeIndex = i
                return
            }
        }

        console.log("Couldn't find start up map type", root.startupMapTypeName)
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("Map Types")

            Repeater {
                model: mapView.map.supportedMapTypes

                MenuItem {
                    checkable: true
                    checked: root.activeMapTypeIndex === index
                    text: modelData.name
                    onTriggered: root.activeMapTypeIndex = index
                }
            }
        }
    }

    MapView {
        id: mapView
        anchors.fill: parent
        map {
            plugin: Plugin {
                name: "osm"

                PluginParameter {
                    name: "osm.mapping.providersrepository.disabled"
                    value: "true"
                }

                PluginParameter {
                    name: "osm.mapping.providersrepository.address"
                    value: "http://maps-redirect.qt.io/osm/5.6/"
                }
            }
            center: QtPositioning.coordinate(59.91, 10.75) // Oslo
            zoomLevel: 14
        }
    }
}
```


  [1]: https://doc.qt.io/qt-6/qml-qtlocation-map.html#supportedMapTypes-prop
  [2]: https://doc.qt.io/qt-6/qml-qtlocation-map.html#activeMapType-prop
  [3]: https://forum.qt.io/topic/118089/error-when-running-minimal-map-example/3
  [4]: https://www.qt.io/blog/2017/03/09/provisioning-openstreetmap-providers-in-qtlocation

## Code in this folder

The example from the answer. The OSM plugin's providers repository is disabled so that
`supportedMapTypes` is not regenerated after startup. A menu lists all supported map
types.

| File | Contents |
| --- | --- |
| [`CMakeLists.txt`](CMakeLists.txt) | CMake project |
| [`main.cpp`](main.cpp) | Application entry point |
| [`Main.qml`](Main.qml) | Map type menu, startup selection and the `MapView` with plugin parameters |

### Build and run

Requires Qt 6.5 or later with these modules: Qt Quick, Qt Location, Qt Positioning.

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/gcc_64
cmake --build build
./build/appDemo76685924
```
