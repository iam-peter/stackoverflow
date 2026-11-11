# QT QML rectangle flickers when rotated by mouse

- **Question:** [stackoverflow.com/q/75081127](https://stackoverflow.com/questions/75081127/qt-qml-rectangle-flickers-when-rotated-by-mouse) by [user2377283](https://stackoverflow.com/users/2377283/user2377283) · January 2023
- **Tags:** `qt` `rotation` `qml`
- **My answer:** [answer 75081861](https://stackoverflow.com/questions/75081127/qt-qml-rectangle-flickers-when-rotated-by-mouse/75081861#75081861) · accepted · score 4 · January 2023

## Question

A rotary knob: a yellow circle should move around a fixed centre while the mouse
drags it, done by rotating the outer rectangle by the angle of the mouse position.
The knob flickers heavily on every mouse move and keeps jumping back towards its
start position.

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/75081127/qt-qml-rectangle-flickers-when-rotated-by-mouse).

## My answer

The issue with your approach is that the `encoder` item is rotating and this will be part of the mouse position mapping as well. You can see that clearly when you rotate half way and then release and grab again. Each following rotation will toggle between two completely different rotation angles hence the flickering.

I solved the issue by giving your component a base `Item` which is static (not affected by rotation) and used for the mapping.

**Edit:** I've improved the rotation calculation by utilizing `Qt.vector2d` and the steps described [here][1] to calculate the angle between 2d vectors.

```qml
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
```

[![enter image description here][2]][2]


  [1]: https://stackoverflow.com/a/16544330/525038
  [2]: https://i.sstatic.net/QGpPz.gif

## Code in this folder

The fixed version from the answer, with the angle calculated from two `Qt.vector2d`s.

| File | Contents |
| --- | --- |
| [`CMakeLists.txt`](CMakeLists.txt) | CMake project |
| [`main.cpp`](main.cpp) | Application entry point |
| [`Main.qml`](Main.qml) | Static base item used for the mapping and the rotating encoder |

### Build and run

Requires Qt 6.5 or later with these modules: Qt Quick.

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/gcc_64
cmake --build build
./build/appDemo75081127
```
