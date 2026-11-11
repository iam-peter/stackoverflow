# Create an empty QStringList directly in a QML file

- **Question:** [stackoverflow.com/q/75085103](https://stackoverflow.com/questions/75085103/create-an-empty-qstringlist-directly-in-a-qml-file) by [smeik](https://stackoverflow.com/users/20983993/smeik) · January 2023
- **Tags:** `qt` `qml`
- **My answer:** [answer 75085320](https://stackoverflow.com/questions/75085103/create-an-empty-qstringlist-directly-in-a-qml-file/75085320#75085320) · score 1 · January 2023

## Question

An external QML module expects a `QStringList` argument, but the asker only has plain
strings. They ask how to build a string list in QML without a C++ helper.

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/75085103/create-an-empty-qstringlist-directly-in-a-qml-file).

## My answer

You can use a JavaScript array of strings or `list<string>` depending on your Qt version. Have a look [here][1].

**main.qml**

```qml
import QtQuick

Rectangle {
    id: root
    width: 640
    height: 480

    property var jsArray: ["apple", "banana", "mango"]
    property list<string> stringList: ["Oslo", "Berlin", "New York"]

    Component.onCompleted: {
        var arr = ["more", "strings", "here"]

        applicationData.setSomething(arr)
        applicationData.setSomething(root.stringList)
        applicationData.setSomething(root.jsArray)
    }
}
```

**main.cpp**

```cpp
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickView>

class ApplicationData : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void setSomething(const QStringList &list) const
    {
        for (const auto &s : list)
            qDebug() << s;
    }
};

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView view;

    ApplicationData data;
    view.rootContext()->setContextProperty("applicationData", &data);
    view.setSource(QUrl(u"qrc:/75085103/main.qml"_qs));
    view.show();

    return app.exec();
}

#include "main.moc"
```

  [1]: https://doc.qt.io/qt-6/qml-list.html

## Code in this folder

The example from the answer. A JavaScript array, a `property var` array and a
`property list<string>` are each passed to a C++ method that takes a `QStringList`
and prints its items.

| File | Contents |
| --- | --- |
| [`CMakeLists.txt`](CMakeLists.txt) | CMake project |
| [`main.cpp`](main.cpp) | `ApplicationData::setSomething(const QStringList &)` |
| [`Main.qml`](Main.qml) | The three ways of passing a string list |

### Build and run

Requires Qt 6.5 or later with these modules: Qt Quick.

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/gcc_64
cmake --build build
./build/appDemo75085103
```
