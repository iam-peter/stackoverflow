import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15

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
