import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: window
    width: 320
    height: 260
    visible: true

    property bool autoSave: true

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            Action { text: qsTr("&New...") }

            Action {
                id: autoSaveAction
                checkable: true
                checked: window.autoSave
                text: qsTr("&Auto Save")
                onToggled: window.autoSave = !window.autoSave
            }
        }
    }
}
