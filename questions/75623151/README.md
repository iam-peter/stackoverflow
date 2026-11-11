# Vertical fade and different color on horizontal

- **Question:** [stackoverflow.com/q/75623151](https://stackoverflow.com/questions/75623151/vertical-fade-and-different-color-on-horizontal) by [S At](https://stackoverflow.com/users/5718019/s-at) · March 2023
- **Tags:** `javascript` `qt` `qml` `fragment` `gradient`
- **My answers:**
  1. [answer 75625509](https://stackoverflow.com/questions/75623151/vertical-fade-and-different-color-on-horizontal/75625509#75625509) · score 3 · March 2023
  2. [answer 75628026](https://stackoverflow.com/questions/75623151/vertical-fade-and-different-color-on-horizontal/75628026#75628026) · accepted · score 1 · March 2023

## Question

The asker wants a horizontal multi-colour gradient that also fades out from top to
bottom, which comes down to blending two images or gradients vertically. They later
added a mock-up of the result and asked whether QML, JavaScript or a fragment shader
is the way to do it.

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/75623151/vertical-fade-and-different-color-on-horizontal).

## My answers

### 1. `OpacityMask` and a fragment shader

From your question I assume you want to merge two images together with some sort of fading from one to the other?

I've used [OpacityMask][a1-1] and [LinearGradient][a1-2] which are both part of the [Qt 5 Compatibility API][a1-3]. Depending on the Qt version you're using you can either use:

- Qt 5 [OpacityMask][a1-4] and [LinearGradient][a1-5]
- Qt 6 [OpacityMask][a1-1] and [LinearGradient][a1-2]
- Qt 6.5 [MultiEffect][a1-6] and [Gradient][a1-7]

The example works as follows:
1. Create a `LinearGradient` that goes from black to transparent which is used as the mask.
2. Load two images (if you don't want to see the original you should hide them with `visible: false`).
3. Create two `OpacityMask` instances on top of each other which both have the same mask applied (bottom is using `invert: true`) and a different source image.

I would also suggest using custom [shaders][a1-8] in order to achieve that effect, because it will be quicker and not as redundant as drawing the `OpacityMask` twice.

----------

**Edit:** I've added the mentioned `ShaderEffect` and the accompanying fragment shader. The result is a bit different to the `OpacityMask` solution, but this might also be due to the GLSL `mix()` function the example is using.

My example is using Qt 6.4.0 you can get the complete source from [here][a1-9].


[![enter image description here][a1-10]][a1-10]

```qml
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
```

----------

```glsl
#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(binding = 1) uniform sampler2D sourceTop;
layout(binding = 2) uniform sampler2D sourceBottom;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
};

void main()
{
    vec4 top = texture(sourceTop, qt_TexCoord0);
    vec4 bottom = texture(sourceBottom, qt_TexCoord0);
    fragColor = mix(top, bottom, qt_TexCoord0.y);
}
```


[a1-1]: https://doc.qt.io/qt-6/qml-qt5compat-graphicaleffects-opacitymask.html
[a1-2]: https://doc.qt.io/qt-6/qml-qt5compat-graphicaleffects-lineargradient.html
[a1-3]: https://doc.qt.io/qt-6/qtgraphicaleffects5-index.html
[a1-4]: https://doc.qt.io/qt-5/qml-qtgraphicaleffects-opacitymask.html
[a1-5]: https://doc.qt.io/qt-5/qml-qtgraphicaleffects-lineargradient.html
[a1-6]: https://doc-snapshots.qt.io/qt6-6.5/qml-qtquick-effects-multieffect.html
[a1-7]: https://doc-snapshots.qt.io/qt6-6.5/qml-qtquick-gradient.html
[a1-8]: https://doc.qt.io/qt-6/qml-qtquick-shadereffect.html
[a1-9]: https://github.com/iam-peter/stackoverflow/tree/main/questions/75623151
[a1-10]: https://i.sstatic.net/Xje8G.png

### 2. Follow-up: single faded gradient (accepted)

Everything you need to solve your issue is already mentioned in my first answer. Please have a read and try to understand the code.

I made another example that does what you want with `OpacityMask`, if you want to do it with shaders take my example from [github][a2-1] to make your shader work and then read about GLSL. There is no tutorial in Qt that teaches you about fragment shaders as it is just using GLSL. The only difficult part with shaders in QML is to make them work, but as said before you can copy my example from github or any other and adapt it.

You should read about [OpacityMask][a2-2] and [LinearGradient][a2-3].

If you want to know more about shaders in QML you should read about [ShaderTools][a2-4], [ShaderEffect][a2-5] and [ShaderEffectSource][a2-6].

[![enter image description here][a2-7]][a2-7]

```qml
LinearGradient {
    id: mask
    anchors.fill: parent
    start: Qt.point(0, 0)
    end: Qt.point(0, root.height)
    visible: false
    gradient: Gradient {
        GradientStop { position: 0.0; color: "black" }
        GradientStop { position: 1.0; color: "transparent" }
    }
}

LinearGradient {
    id: gradientSource
    anchors.fill: parent
    start: Qt.point(0, 0)
    end: Qt.point(root.width, 0)
    visible: false
    gradient: Gradient {
        GradientStop { position: 0.0; color: "yellow" }
        GradientStop { position: 1.0; color: "red" }
    }
}

Item {
    anchors.fill: parent
/*
    Image { // transparency checkerboard
        anchors.fill: parent
        fillMode: Image.Tile
        source: "qrc:/images/checkers.png"
    }
*/
    OpacityMask {
        anchors.fill: parent
        source: gradientSource
        maskSource: mask
    }
}
```


[a2-1]: https://github.com/iam-peter/stackoverflow/tree/main/questions/75623151
[a2-2]: https://doc.qt.io/qt-6/qml-qt5compat-graphicaleffects-opacitymask.html
[a2-3]: https://doc.qt.io/qt-6/qml-qt5compat-graphicaleffects-lineargradient.html
[a2-4]: https://doc.qt.io/qt-6/qtshadertools-build.html
[a2-5]: https://doc.qt.io/qt-6/qml-qtquick-shadereffect.html
[a2-6]: https://doc.qt.io/qt-6/qml-qtquick-shadereffectsource.html
[a2-7]: https://i.sstatic.net/DE8j8.png

## Code in this folder

The complete source of the first answer: two `OpacityMask` rows (photos and
gradients) and the same blend as a `ShaderEffect`. The photos are loaded from
picsum.photos, so the first and last rows need an internet connection.

| File | Contents |
| --- | --- |
| [`CMakeLists.txt`](CMakeLists.txt) | CMake project |
| [`main.cpp`](main.cpp) | Application entry point |
| [`Main.qml`](Main.qml) | The three example rows |
| [`shaders/blend.frag`](shaders/blend.frag) | Mixes the two textures by the vertical texture coordinate |

### Build and run

Requires Qt 6.5 or later with these modules: Qt Quick, Qt Shader Tools, Qt 5 Compatibility module (for `Qt5Compat.GraphicalEffects`).

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/gcc_64
cmake --build build
./build/appDemo75623151
```
