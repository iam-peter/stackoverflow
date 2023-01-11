import QtQuick

Window {
    id: root
    width: 240
    height: 240
    visible: true

    Item {
        id: base

        property real centerX: base.width / 2
        property real centerY: base.height / 2

        height: 150
        width: base.height
        anchors.centerIn: parent

        Rectangle {
            id: encoder
            anchors.fill: parent
            radius: encoder.height / 2
            color: "lightgreen"
            antialiasing: true

            Rectangle {
                id: center
                height: parent.height * 0.4
                width: center.height
                radius: center.height / 2
                color: "darkgreen"
                border.color: "black"
                border.width: centerMouseArea.pressed ? 2 : 0
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                MouseArea {
                    id: centerMouseArea
                    anchors.fill: parent
                }
            }

            Rectangle {
                id: knob
                height: parent.height * 0.2
                width: knob.height
                radius: knob.height / 2
                color: "yellow"
                anchors {
                    top: parent.top
                    margins: 10
                    horizontalCenter: parent.horizontalCenter
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onPositionChanged: function(mouse) {
                        var point = mapToItem(base, mouse.x, mouse.y)

                        var a = Qt.vector2d(0, -base.centerY)
                        var b = Qt.vector2d(point.x - base.centerX, point.y - base.centerY)

                        var dot = a.dotProduct(b) // dot product
                        var det = a.x * b.y - a.y * b.x // determinant

                        encoder.rotation = Math.atan2(det, dot) * 180 / Math.PI
                    }
                }
            }
        }
    }
}
