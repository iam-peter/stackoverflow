# QML PolarChart point label on hover

- **Question:** [stackoverflow.com/q/76248716](https://stackoverflow.com/questions/76248716/qml-polarchart-point-label-on-hover) by [Prain](https://stackoverflow.com/users/7651851/prain) · May 2023
- **Tags:** `charts` `qml` `label` `hover` `tooltip`
- **My answer:** [answer 76279084](https://stackoverflow.com/questions/76248716/qml-polarchart-point-label-on-hover/76279084#76279084) · accepted · score 1 · May 2023

## Question

Starting from the QML PolarChart example, the asker wants to see the value of one
point when hovering over it or clicking it, as a label or tooltip, because showing
labels for every point is too cluttered. Only Qt 5.15 is available to them.

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/76248716/qml-polarchart-point-label-on-hover).

## My answer

This is how you would solve your question (basically your solution). I just want to confirm that it is not a workaround, what makes you feel this way? You use the functionality that is provided by the ChartView types to solve your task.

By using the [`hovered(point point, bool state)`][1] signal you can handle when a point is hovered (`state = true`) and loses hover again (`state = false`). Using the [`mapToPosition`][2] function given by the `ChartView` you can convert the data point into a position to assign that to the `ToolTip`.

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15

ChartView {
    id: chart
    width: 640
    height: 480
    antialiasing: true

    ToolTip {
        id: toolTip
        visible: false
    }

    ScatterSeries {
        id: scatter
        name: "Scatter"
        axisX: ValueAxis { min: 1; max: 3 }
        axisY: ValueAxis { min: 1; max: 2.5 }

        XYPoint { x: 1.5; y: 1.5 }
        XYPoint { x: 1.5; y: 1.6 }
        XYPoint { x: 1.57; y: 1.55 }
        XYPoint { x: 1.8; y: 1.8 }
        XYPoint { x: 1.9; y: 1.6 }
        XYPoint { x: 2.1; y: 1.3 }
        XYPoint { x: 2.5; y: 2.1 }

        onHovered: function(point, state) {
            toolTip.text = point.x + ", " + point.y
            toolTip.visible = state
            let p = chart.mapToPosition(point, scatter)
            toolTip.x = p.x
            toolTip.y = p.y - toolTip.height
        }
    }
}
```

[![enter image description here][3]][3]

----------
**UPDATE**

To get the ToolTips for the upper series of an `AreaSeries` only you would need to listen to the signal of this exact `LineSeries` as shown below. Unfortunately the `point` that is given as the parameter of the `LineSeries` hovered signal depends on where you put the mouse cursor at and isn't restricted to the provided points only as with a `ScatterSeries`. So you usually get interpolated points with a lot of decimal places. You could work around that by drawing a `ScatterSeries` on top of the `AreaSeries` and use the `hovered` signal from that series instead. If you want that though you could round the values for smaller tool tips.

```qml
PolarChartView {
    id: chart
    title: "Some Polar Area Series"
    width: 640
    height: 480
    legend.visible: false
    antialiasing: true

    ToolTip {
        id: toolTip
        visible: false
    }

    ValueAxis { id: axis1 }
    ValueAxis { id: axis2 }

    LineSeries {
        id: lowerLine
        axisAngular: axis1
        axisRadial: axis2

        // Please note that month in JavaScript months are zero based, so 2 means March
        XYPoint { x: 0;  y: 15 }
        XYPoint { x: 2;  y: 35 }
        XYPoint { x: 3;  y: 50 }
        XYPoint { x: 5;  y: 75 }
        XYPoint { x: 6;  y: 102 }
        XYPoint { x: 9;  y: 132 }
        XYPoint { x: 10;  y: 100 }
        XYPoint { x: 12;  y: 120 }
        XYPoint { x: 16;  y: 140 }
        XYPoint { x: 20;  y: 150 }
    }
    LineSeries {
        id: upperLine
        axisAngular: axis1
        axisRadial: axis2

        // Please note that month in JavaScript months are zero based, so 2 means March
        XYPoint { x: 0; y: 30 }
        XYPoint { x: 2; y: 55 }
        XYPoint { x: 3; y: 80 }
        XYPoint { x: 5; y: 105 }
        XYPoint { x: 6; y: 125 }
        XYPoint { x: 9; y: 160 }
        XYPoint { x: 10; y: 140 }
        XYPoint { x: 12; y: 140 }
        XYPoint { x: 16; y: 170 }
        XYPoint { x: 20; y: 200 }

        onHovered: function(point, state) {
            toolTip.text = point.x + ", " + point.y
            toolTip.visible = state
            let p = chart.mapToPosition(point, upperLine)
            toolTip.x = p.x
            toolTip.y = p.y - toolTip.height
        }
    }

    AreaSeries {
        axisAngular: axis1
        axisRadial: axis2
        lowerSeries: lowerLine
        upperSeries: upperLine
    }
}
```

[![enter image description here][4]][4]


  [1]: https://doc.qt.io/qt-6/qml-qtcharts-xyseries.html#hovered-signal
  [2]: https://doc.qt.io/qt-6/qml-qtcharts-chartview.html#mapToPosition-method
  [3]: https://i.sstatic.net/uphXx.png
  [4]: https://i.sstatic.net/zb39w.png

## Code in this folder

The `PolarChartView` variant from the update in the answer. It shows a `ToolTip` for the
upper `LineSeries` of an `AreaSeries`. The asker was limited to Qt 5.15, so this is
a qmake project with Qt 5.15 imports. It also builds with Qt 6's qmake.

| File | Contents |
| --- | --- |
| [`76248716.pro`](76248716.pro) | qmake project |
| [`main.cpp`](main.cpp) | Shows `main.qml` in a `QQuickWidget` (Qt Charts needs a `QApplication`) |
| [`main.qml`](main.qml) | `PolarChartView` with the hover `ToolTip` |
| [`qml.qrc`](qml.qrc) | Resource file that embeds `main.qml` |

### Build and run

Requires Qt 5.15 or later with these modules: Qt Quick, Qt Quick Controls 2, Qt Charts, Qt Quick Widgets.

```bash
mkdir build && cd build
~/Qt/5.15.2/gcc_64/bin/qmake ..
make
./76248716
```
