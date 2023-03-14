import QtQuick

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    ShaderEffectSource {
        id: shaderEffectSource
        sourceItem: item
    }

    Row {
        anchors.centerIn: parent
        spacing: 40

        Item {
            id: item
            width: 300
            height: 300

            Rectangle {
                width: 200
                height: 200
                anchors.centerIn: parent
                color: "salmon"
            }
        }

        ShaderEffect {
            width: 300
            height: 300
            property variant source: shaderEffectSource
            property variant shadow: ShaderEffectSource {
                sourceItem: ShaderEffect {
                    width: item.width
                    height: item.height
                    property variant delta: Qt.size(0.0, 1.0 / height)
                    property variant source: ShaderEffectSource {
                        sourceItem: ShaderEffect {
                            width: item.width
                            height: item.height
                            property variant delta: Qt.size(1.0 / width, 0.0)
                            property variant source: shaderEffectSource
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
}
