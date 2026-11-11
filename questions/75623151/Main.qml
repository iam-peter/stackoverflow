import QtQuick
import Qt5Compat.GraphicalEffects

Window {
    id: root
    width: 640
    height: 940
    visible: true
    title: qsTr("Hello World")

    readonly property int _width: 200
    readonly property int _height: 300

    LinearGradient {
        id: mask
        width: root._width
        height: root._height
        start: Qt.point(0, 0)
        end: Qt.point(0, root._height)
        visible: false
        gradient: Gradient {
            GradientStop { position: 0.0; color: "black" }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    Grid {
        columns: 3
        spacing: 20

        Image {
            id: imgSourceTop
            source: "https://picsum.photos/id/54/%1/%2".arg(root._width).arg(root._height)
            smooth: true
        }

        Image {
            id: imgSourceBottom
            source: "https://picsum.photos/id/93/%1/%2".arg(root._width).arg(root._height)
            smooth: true
        }

        Item {
            width: root._width
            height: root._height

            OpacityMask {
                anchors.fill: parent
                source: imgSourceTop
                maskSource: mask
            }

            OpacityMask {
                anchors.fill: parent
                source: imgSourceBottom
                maskSource: mask
                invert: true
            }
        }

        LinearGradient {
            id: gradientSourceTop
            width: root._width
            height: root._height
            start: Qt.point(0, 0)
            end: Qt.point(root._width, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#1E9600" }
                GradientStop { position: 0.5; color: "#FFF200" }
                GradientStop { position: 1.0; color: "#FF0000" }
            }
        }

        LinearGradient {
            id: gradientSourceBottom
            width: root._width
            height: root._height
            start: Qt.point(0, 0)
            end: Qt.point(root._width, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#833ab4" }
                GradientStop { position: 0.5; color: "#fd1d1d" }
                GradientStop { position: 1.0; color: "#fcb045" }
            }
        }

        Item {
            width: root._width
            height: root._height

            OpacityMask {
                anchors.fill: parent
                source: gradientSourceTop
                maskSource: mask
            }

            OpacityMask {
                anchors.fill: parent
                source: gradientSourceBottom
                maskSource: mask
                invert: true
            }
        }

        Image {
            id: shaderSourceTop
            source: "https://picsum.photos/id/54/%1/%2".arg(root._width).arg(root._height)
            smooth: true
        }

        Image {
            id: shaderSourceBottom
            source: "https://picsum.photos/id/93/%1/%2".arg(root._width).arg(root._height)
            smooth: true
        }

        ShaderEffect {
            width: root._width
            height: root._height
            property variant sourceTop: shaderSourceTop
            property variant sourceBottom: shaderSourceBottom
            fragmentShader: "shaders/blend.frag.qsb"
        }
    }
}
