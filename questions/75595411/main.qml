import QtQuick

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    ShaderEffectSource {
        id: theSource
        sourceItem: theItem
    }

    Row {
        anchors.centerIn: parent
        spacing: 40

        Item {
            id: theItem
            width: 160
            height: 160

            Rectangle {
                id: mrect
                width: 100
                height: 100
                anchors.centerIn: parent
                color: "yellow"
            }
        }

        ShaderEffect {
            width: 160
            height: 160
            property variant source: theSource
            property variant shadow: ShaderEffectSource {
                sourceItem: ShaderEffect {
                    width: theItem.width
                    height: theItem.height
                    property variant delta: Qt.size(0.0, 1.0 / height)
                    property variant source: ShaderEffectSource {
                        sourceItem: ShaderEffect {
                            width: theItem.width
                            height: theItem.height
                            property variant delta: Qt.size(1.0 / width, 0.0)
                            property variant source: theSource
                            fragmentShader: "shaders/blur.frag.qsb"
                        }
                    }
                    fragmentShader: "shaders/blur.frag.qsb"
                }
            }
            property real angle: 0.5
            property variant offset: Qt.point(15.0 * Math.cos(angle), 15.0 * Math.sin(angle))
            property variant delta: Qt.size(offset.x / width, offset.y / height)
            property real darkness: 0.2
            fragmentShader: "shaders/shadow.frag.qsb"
        }
    }

/*
        ShaderEffect {
            id: shadow
            width: mrect.width
            height: mrect.height
            anchors.centerIn: parent

            property variant source: theSource
            property variant shadow: ShaderEffectSource {
                sourceItem: ShaderEffect {
                    width: mrect.width
                    height: mrect.height
                    property variant delta: Qt.size(0.0, 1.0 / height)
                    property variant source: ShaderEffectSource {
                        sourceItem: ShaderEffect {
                            width: mrect.width * 1.5
                            height: mrect.height * 1.5
                            property variant delta: Qt.size(1.0 / width, 0.0)
                            property variant source: theSource
                            fragmentShader: "shaders/blur.frag.qsb"
                        }
                    }
                    fragmentShader: "shaders/blur.frag.qsb"
                }
            }

            property real angle: 0.5
            property variant delta: Qt.size(15 / width, 15 / height)
            property real darkness: 0.2
            fragmentShader: "shaders/shadow.frag.qsb"
        }
*/
}
