import QtQuick
import FooBar
import Demo77967427

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    property list<DataObject> myModel: Backend.model

    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10
        orientation: ListView.Vertical

        model: root.myModel

        delegate: Item {
            id: myItem
            required property string name

            width: label.width
            height: label.height
            Text {
                id: label
                text: myItem.name
                font.pointSize: 24
            }
        }

        header: Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 48
            font.bold: true

            text: Backend.header
        }
    }
}
