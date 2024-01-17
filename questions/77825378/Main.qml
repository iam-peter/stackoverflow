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
