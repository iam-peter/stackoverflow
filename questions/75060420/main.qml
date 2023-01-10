import QtQuick
import QtQuick.Controls

Rectangle {
    width: 640
    height: 480

    signal changeLanguage(string value)

    Column {
        anchors.centerIn: parent

        Text {
            text: qsTr("Hello")
        }
        Text {
            text: qsTr("Rectangle")
        }

        ComboBox {
            id: languageSwitch
            model: ["en", "de"]
            onActivated: translationTest.selectLanguage(languageSwitch.currentValue)
            Component.onCompleted: {
                languageSwitch.currentIndex = languageSwitch.find(translationTest.language)
            }
        }

        Component.onCompleted: {
            QT_TR_NOOP("Apple")
        }
    }
}
