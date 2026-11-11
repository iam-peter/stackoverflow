import QtQuick
import QtQuick.Controls
import QtLocation
import QtPositioning
import QtQml.Models

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
