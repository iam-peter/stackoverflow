import QtQuick
import FooBar
import Test

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

        model: root.myModel // this doesn't show anything in the listview

        delegate: Item {
            id: myItem
            required property string name

            width: label.width
            height: label.height
            Text {
                id: label
                text: myItem.name // modelData.name
                font.pointSize: 24
            }
        }

        header: Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 48
            font.bold: true

            text: Backend.header // This works as expected
        }
    }
}
