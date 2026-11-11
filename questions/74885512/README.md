# Qt Select At Most 1 Marker on Map

- **Question:** [stackoverflow.com/q/74885512](https://stackoverflow.com/questions/74885512/qt-select-at-most-1-marker-on-map) by [Mete Korucu](https://stackoverflow.com/users/14292457/mete-korucu) · December 2022
- **Tags:** `qt` `qml` `qt5`
- **My answers:**
  1. [answer 74886854](https://stackoverflow.com/questions/74885512/qt-select-at-most-1-marker-on-map/74886854#74886854) · accepted · score 1 · December 2022
  2. [answer 74889445](https://stackoverflow.com/questions/74885512/qt-select-at-most-1-marker-on-map/74889445#74889445) · score 1 · December 2022
  3. [answer 74898702](https://stackoverflow.com/questions/74885512/qt-select-at-most-1-marker-on-map/74898702#74898702) · score 1 · December 2022

## Question

Markers on a QtLocation `Map` (`MapQuickItem` delegates) toggle between a red and
a green pushpin on click, but each marker keeps its own state, so any number of them
can be selected at once. The asker wants single selection: clicking a marker should
deselect the previous one, and clicking an empty part of the map should deselect all.

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/74885512/qt-select-at-most-1-marker-on-map).

## My answers

### 1. `selected` role in the ListModel (accepted)

In QML this is usually done with using a `ButtonGroup`, but as you're not using `AbstractButton`s you need to write it yourself. Here is my solution for it.

I've used the `ListModel` to not only store the coordinates of each marker, but also a `selected` flag which is set to `false` by default. In the delegate I'm using the selected data role to show if a marker is selected or not.

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15

ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Map")

    ListModel { id: markerModel }

    Plugin {
        id: mapPlugin
        name: "osm"
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(59.91, 10.75) // Oslo
        zoomLevel: 14

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
                var coordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                var jsonObject = JSON.parse(JSON.stringify(coordinate))
                jsonObject["selected"] = false
                markerModel.append(jsonObject)
            }

            onClicked: map.deselectAll()
        }

        MapItemView {
            model: markerModel
            delegate: markerDelegate
        }

        function deselectAll() {
            for (var i = 0; i < markerModel.count; ++i)
                markerModel.setProperty(i, "selected", false)
        }

        Component {
            id: markerDelegate

            MapQuickItem {
                id: markerItem

                required property int index
                required property real latitude
                required property real longitude
                required property bool selected

                anchorPoint.x: waypointMarker.width / 2
                anchorPoint.y: waypointMarker.height / 2
                coordinate: QtPositioning.coordinate(latitude, longitude)

                sourceItem: Rectangle {
                    id: waypointMarker
                    width: 20
                    height: 20
                    radius: 20
                    border.width: 1
                    border.color: mouseArea.containsMouse ? "red" : "black"
                    color: markerItem.selected ? "red" : "gray"
                }

                MouseArea {
                    id: mouseArea
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: {
                        map.deselectAll()
                        markerModel.setProperty(markerItem.index, "selected", true)
                    }
                }
            }
        }
    }
}
```

[![demo][a1-1]][a1-1]


[a1-1]: https://i.sstatic.net/8iUId.gif

### 2. Store the selected index

I came up with yet another solution without looping over all items in the model. It just stores the index of the selected marker in a dedicated property. This has the drawback that if the model order changes the index can become invalid, also potential multi selection is hard to handle, but on the other hand it is faster because it doesn't need to iterate over all items.

I experimented a lot with [DelegateModel][a2-1], it seems to be a perfect match if one could use it in combination with `MapItemView`, because of the `groups` and the attached properties like `inGroupName`.
After that I've tried [ItemSelectionModel][a2-2], but it seems it is only intended to be used in combination with a view, e.g. `TreeView`. I couldn't find out how to generate a `QModelIndex` in QML without a `TreeView`.

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Map")

    property int selectedMarker: -1

    Map {
        id: map
        anchors.fill: parent
        plugin: Plugin {
            id: mapPlugin
            name: "osm"
        }
        center: QtPositioning.coordinate(59.91, 10.75) // Oslo
        zoomLevel: 14

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
                var coordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                markerModel.append(JSON.parse(JSON.stringify(coordinate)))
            }

            onClicked: root.selectedMarker = -1
        }

        MapItemView {
            model: ListModel { id: markerModel }
            delegate: markerDelegate
        }

        Component {
            id: markerDelegate

            MapQuickItem {
                id: markerItem

                required property int index
                required property real latitude
                required property real longitude

                anchorPoint.x: waypointMarker.width / 2
                anchorPoint.y: waypointMarker.height / 2
                coordinate: QtPositioning.coordinate(latitude, longitude)

                sourceItem: Rectangle {
                    id: waypointMarker
                    width: 20
                    height: 20
                    radius: 20
                    border.width: 1
                    border.color: mouseArea.containsMouse ? "red" : "black"
                    color: markerItem.index === root.selectedMarker ? "red" : "gray"
                }

                MouseArea {
                    id: mouseArea
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: root.selectedMarker = markerItem.index
                }
            }
        }
    }
}
```

[a2-1]: https://doc.qt.io/qt-5/qml-qtqml-models-delegatemodel.html
[a2-2]: https://doc.qt.io/qt-5/qml-qtqml-models-itemselectionmodel.html

### 3. `ItemSelectionModel`

I promise this is the last answer on that question.

This one is using an [ItemSelectionModel][a3-1] and a few undocumented functions, e.g. `ListModel.index(row, col)`.

`itemSelectionModel.hasSelection` is used in the `color` binding to trigger a reevaluation in order to call `isRowSelected` and set the color accordingly whenever the selection has changed.

If the user clicks on the background the [clear()][a3-3] is called to clear the selection.

I think out of the three this is the best solution. It can be easily upgraded to allow multi selection as shown below. Also the `ItemSelectionModel` can be used by other views to show the data and selection.

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15
import QtQml.Models 2.15
    
ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Map")

    Map {
        id: map
        anchors.fill: parent
        plugin: Plugin {
            id: mapPlugin
            name: "osm"
        }
        center: QtPositioning.coordinate(59.91, 10.75) // Oslo
        zoomLevel: 14

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: function(mouse) {
                markerModel.append(map.toCoordinate(Qt.point(mouse.x, mouse.y)))
            }

            onClicked: itemSelectionModel.clear()
        }

        MapItemView {
            model: ListModel { id: markerModel }
            delegate: markerDelegate
        }

        ItemSelectionModel {
            id: itemSelectionModel
            model: markerModel
        }

        Component {
            id: markerDelegate

            MapQuickItem {
                id: markerItem

                required property int index
                required property real latitude
                required property real longitude

                anchorPoint.x: waypointMarker.width / 2
                anchorPoint.y: waypointMarker.height / 2
                coordinate: QtPositioning.coordinate(latitude, longitude)

                sourceItem: Rectangle {
                    id: waypointMarker
                    width: 20
                    height: 20
                    radius: 20
                    border.width: 1
                    border.color: mouseArea.containsMouse ? "red" : "black"
                    color: {
                        itemSelectionModel.hasSelection
                        return itemSelectionModel.isRowSelected(markerItem.index) ? "red" : "gray"
                    }
                }

                MouseArea {
                    id: mouseArea
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: itemSelectionModel.select(markerModel.index(markerItem.index, 0),
                                                         ItemSelectionModel./*ClearAnd*/Select)
                }
            }
        }
    }
}
```


[a3-1]: https://doc.qt.io/qt-5/qml-qtqml-models-itemselectionmodel.html
[a3-2]: https://doc.qt.io/qt-5/qml-qtqml-models-itemselectionmodel.html#select-method
[a3-3]: https://doc.qt.io/qt-5/qml-qtqml-models-itemselectionmodel.html#clear-method

## Code in this folder

The folder contains the third answer (`ItemSelectionModel`), ported to Qt 6 imports.
Double-click the map to add markers, click a marker to select it and click the
background to clear the selection.

| File | Contents |
| --- | --- |
| [`CMakeLists.txt`](CMakeLists.txt) | CMake project |
| [`main.cpp`](main.cpp) | Application entry point |
| [`Main.qml`](Main.qml) | Map, marker delegate and the `ItemSelectionModel` |

### Build and run

Requires Qt 6.5 or later with these modules: Qt Quick, Qt Location, Qt Positioning.

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/gcc_64
cmake --build build
./build/appDemo74885512
```
