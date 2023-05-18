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
