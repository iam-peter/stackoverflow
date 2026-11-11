# How to do QObject::connect to QJSValue?

- **Question:** [stackoverflow.com/q/75069400](https://stackoverflow.com/questions/75069400/how-to-do-qobjectconnect-to-qjsvalue) by user20973570 · January 2023
- **Tags:** `qt` `qml`
- **My answer:** [answer 75073030](https://stackoverflow.com/questions/75069400/how-to-do-qobjectconnect-to-qjsvalue/75073030#75073030) · score 0 · January 2023

## Question

In QML a signal can be connected to a JavaScript function with `signal.connect(fn)`.
The asker wants to do the same from C++: `QObject::connect()` a signal to a callable
`QJSValue`.

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/75069400/how-to-do-qobjectconnect-to-qjsvalue).

## My answer

This will work. I got the solution from this [SO post][1]. That said, I don't know if it aligns with the Qt way of doing it. Their [example][2] of invoking a QML method uses [QMetaObject::invokeMethod()][3].

**main.cpp**

```cpp
#include <QGuiApplication>
#include <QQuickItem>
#include <QQuickView>

class MyClass : public QObject
{
    Q_OBJECT
signals:
    void cppSignal(const QString &msg);
};

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView view(QUrl(u"qrc:/75069400/main.qml"_qs));
    view.show();

    QObject *item = view.rootObject();
    MyClass myClass;
    QObject::connect(&myClass, SIGNAL(cppSignal(QString)),
                     item, SLOT(callFromCpp(QString)));

    emit myClass.cppSignal("this is a test");

    return app.exec();
}

#include "main.moc"
```

**main.qml**

```qml
import QtQuick

Rectangle {
    width: 320
    height: 240

    function callFromCpp(value : string) {
        console.log("QML" , value)
    }
}
```


  [1]: https://stackoverflow.com/a/71060709/525038
  [2]: https://doc.qt.io/qt-6/qtqml-cppintegration-interactqmlfromcpp.html#invoking-qml-methods
  [3]: https://doc.qt.io/qt-6/qmetaobject.html#invokeMethod

## Code in this folder

The example from the answer. A C++ signal is connected to a function on the root
QML item with the string-based `SIGNAL`/`SLOT` syntax and prints
`QML this is a test`.

| File | Contents |
| --- | --- |
| [`CMakeLists.txt`](CMakeLists.txt) | CMake project |
| [`main.cpp`](main.cpp) | `MyClass` with `cppSignal()` and the connection to the QML function |
| [`Main.qml`](Main.qml) | Root item with `callFromCpp()` |

### Build and run

Requires Qt 6.5 or later with these modules: Qt Quick.

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/gcc_64
cmake --build build
./build/appDemo75069400
```
