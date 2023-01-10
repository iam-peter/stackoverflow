import QtQuick

Rectangle {
    width: 320
    height: 240

    function callFromCpp(value : string) {
        console.log("QML" , value)
    }
}
