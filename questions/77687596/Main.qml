import QtQuick

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Component.onCompleted: console.log(myClass.test)
}
