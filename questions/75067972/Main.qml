import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Button {
        anchors.centerIn: parent
        text: qsTr("File Dialog")
        onClicked: fileDialog.open()
    }

    FileDialog { id: fileDialog }
}
