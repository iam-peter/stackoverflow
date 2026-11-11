# QML Item cliping shadow ShaderEffect

- **Question:** [stackoverflow.com/q/75595411](https://stackoverflow.com/questions/75595411/qml-item-cliping-shadow-shadereffect) by [UkRiP](https://stackoverflow.com/users/19137683/ukrip) · February 2023
- **Tags:** `qt` `qml` `shader`
- **My answer:** [answer 75733693](https://stackoverflow.com/questions/75595411/qml-item-cliping-shadow-shadereffect/75733693#75733693) · accepted · score 0 · March 2023

## Question

Moving a drop shadow from Qt Graphical Effects to Qt 6, the asker built one from a
`ShaderEffect` and the blur and shadow shaders of the Qt ShaderEffects example. The
shadow is clipped to the bounds of the source item, so nothing appears outside the
rectangle.

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/75595411/qml-item-cliping-shadow-shadereffect).

## My answer

You need to give the `sourceItem` of the `ShaderEffectSource` a padding depending on how big the offset of your shadow will get. The issue is that the `sourceItem` is used to pick the color from and also draw on top of it.

```qml
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
```

[![enter image description here][1]][1]


  [1]: https://i.sstatic.net/lwrWk.png

## Code in this folder

The example from the answer. The source `Item` is larger than the visible rectangle,
which leaves room for the shadow. The shaders are compiled to `.qsb` at build time by
`qt_add_shaders()`.

| File | Contents |
| --- | --- |
| [`CMakeLists.txt`](CMakeLists.txt) | CMake project |
| [`main.cpp`](main.cpp) | Application entry point |
| [`Main.qml`](Main.qml) | Padded source item and the two-pass blur and shadow `ShaderEffect` |
| [`shaders/blur.frag`](shaders/blur.frag) | One-dimensional Gaussian blur, run once horizontally and once vertically |
| [`shaders/shadow.frag`](shaders/shadow.frag) | Draws the source over its offset, darkened shadow |

### Build and run

Requires Qt 6.5 or later with these modules: Qt Quick, Qt Shader Tools.

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/gcc_64
cmake --build build
./build/appDemo75595411
```
