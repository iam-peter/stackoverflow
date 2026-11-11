# Binding QML ItemModelSurfaceDataProxy wiht a C++ model in Qt

- **Question:** [stackoverflow.com/q/77825378](https://stackoverflow.com/questions/77825378/binding-qml-itemmodelsurfacedataproxy-wiht-a-c-model-in-qt) by [am_289](https://stackoverflow.com/users/8207506/am-289) · January 2024
- **Tags:** `c++` `qt` `qml`
- **My answer:** [answer 77833508](https://stackoverflow.com/questions/77825378/binding-qml-itemmodelsurfacedataproxy-wiht-a-c-model-in-qt/77833508#77833508) · accepted · score 1 · January 2024

## Question

The asker wants to show a `cv::Mat` as a 3D surface. They bind a C++
`QAbstractTableModel` to an `ItemModelSurfaceDataProxy` in a QML `Surface3D`, but the
surface stays empty and they suspect the role names.

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/77825378/binding-qml-itemmodelsurfacedataproxy-wiht-a-c-model-in-qt).

## My answer

This example is using [`QSurfaceDataProxy`](https://doc.qt.io/qt-6.5/qsurfacedataproxy.html) to provide the [`Surface3DSeries`](https://doc.qt.io/qt-6.5/qml-qtdatavisualization-surface3dseries.html) with data. The constructor of `MatData` which is derived from `QSurfaceDataProxy` contains the creation of a `cv::Mat` with random data and maps it to a `QSurfaceDataArray`. The key here is the call to [`resetArray()`](https://doc.qt.io/qt-6/qsurfacedataproxy.html#resetArray) which will replace the `QSurface3DSeries` of the `QSurfaceDataProxy` with the provided data.

I'm using Qt 6.5.4 hence the import for `Surface3D` and `Surface3DSeries` is QtDataVisualization instead of QtGraphs. If you use Qt 6.6 or higher you can adapt the imports.

There is a small hack in the constructor which is a workaround for the following issue reported in [QTBUG-58884](https://bugreports.qt.io/browse/QTBUG-58884), [QTBUG-65322](https://bugreports.qt.io/browse/QTBUG-65322) and [QTBUG-103965](https://bugreports.qt.io/browse/QTBUG-103965). The last bugreport had a comment with the workaround I'm using.

You can find the full source code for the example over [here](https://github.com/iam-peter/stackoverflow/tree/main/questions/77825378).

```cpp
MatData::MatData(QObject *parent)
    : QSurfaceDataProxy(parent)
{
    // Create a cv::Mat to be used as surface
    cv::Mat test(20, 20, CV_32F);
    cv::Mat mean = cv::Mat::zeros(1, 1, CV_32F);
    cv::Mat sigma = cv::Mat::ones(1, 1, CV_32F);
    sigma.at<float>(0, 0, 0) = 10;

    cv::RNG rng;
    rng.fill(test, cv::RNG::NORMAL, mean, sigma);

    cv::Mat mat;
    blur(test, mat, cv::Size(5, 5));

    m_dataArray = new QSurfaceDataArray;
    m_dataArray->reserve(mat.rows);

    for (int i = 0; i < mat.rows; i++) {
        QSurfaceDataRow *newProxyRow = new QSurfaceDataRow(mat.cols);
        m_dataArray->append(newProxyRow);

        for (int j = 0; j < mat.cols; j++) {
            QSurfaceDataItem &item = (*newProxyRow)[j];
            item.setPosition(QVector3D(i, mat.at<float>(i, j), j));

            // https://bugreports.qt.io/browse/QTBUG-103965
            auto tmp = (*newProxyRow)[j];
            tmp.setPosition(QVector3D(tmp.z(), tmp.y(), tmp.x()));
            (*newProxyRow)[j] = tmp;
        }
    }

    resetArray(m_dataArray);
}
```

```qml
import QtQuick
import QtDataVisualization
import CustomProxy

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("Hello World")

    ColorGradient {
        id: surfaceGradient
        ColorGradientStop { position: 0.0; color: "black" }
        ColorGradientStop { position: 0.2; color: "red" }
        ColorGradientStop { position: 0.5; color: "blue" }
        ColorGradientStop { position: 0.8; color: "yellow" }
        ColorGradientStop { position: 1.0; color: "white" }
    }

    Surface3D {
        id: surfaceGraph
        anchors.fill: parent

        Surface3DSeries {
            id: surfaceSeries
            flatShadingEnabled: false
            drawMode: Surface3DSeries.DrawSurface | Surface3DSeries.DrawWireframe
            baseGradient: surfaceGradient
            colorStyle: Theme3D.ColorStyleRangeGradient
            itemLabelFormat: "(@xLabel, @zLabel): @yLabel"

            MatData {}
        }
    }
}
```
[![Screenshot of the application][1]][1]


  [1]: https://i.sstatic.net/DkcCk.png

## Code in this folder

The full example linked from the answer. `MatData` creates a blurred random 20 x 20
`cv::Mat` and turns it into a `QSurfaceDataArray`, including the workaround for
QTBUG-103965. It uses Qt Data Visualization, as in the answer. For Qt 6.6 and later
you can port it to Qt Graphs. It needs a real OpenGL context and crashes with
`QT_QPA_PLATFORM=offscreen`.

| File | Contents |
| --- | --- |
| [`CMakeLists.txt`](CMakeLists.txt) | CMake project |
| [`main.cpp`](main.cpp) | Registers `MatData` in the `CustomProxy` module |
| [`Main.qml`](Main.qml) | `Surface3D` with a gradient and the `MatData` proxy |
| [`matdata.cpp`](matdata.cpp) | Builds the surface data from the `cv::Mat` |
| [`matdata.h`](matdata.h) | `MatData`, a `QSurfaceDataProxy` registered as a QML type |

### Build and run

Requires Qt 6.5 or later with these modules: Qt Quick, Qt Data Visualization, and OpenCV.

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/gcc_64
cmake --build build
./build/appDemo77825378
```
