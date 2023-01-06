import QtQuick
import QtCharts

Item {
    width: 800
    height: 200

    ChartView{
        id: dataChartView
        animationOptions: ChartView.NoAnimation
        antialiasing: true
        anchors.fill: parent

        ValueAxis {
            id: axisXdata
            min: dataModel.xMin
            max: dataModel.xMax
        }

        ValueAxis {
            id: axisYdata
            min: 0
            max: 1
        }

        LineSeries {
            id:  dataLineSeries
            name: "Angle"
            axisX: axisXdata
            axisY: axisYdata
            useOpenGL: true
        }

        VXYModelMapper {
            id:  dataModelMapper
            model: dataModel
            series: dataLineSeries
            firstRow: 0
            xColumn: 0
            yColumn: 1
        }
    }
}
