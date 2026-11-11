import QtQuick

Rectangle {
    id: root
    width: 640
    height: 480

    property var jsArray: ["apple", "banana", "mango"]
    property list<string> stringList: ["Oslo", "Berlin", "New York"]

    Component.onCompleted: {
        var arr = ["more", "strings", "here"]

        applicationData.setSomething(arr)
        applicationData.setSomething(root.stringList)
        applicationData.setSomething(root.jsArray)
    }
}
