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
