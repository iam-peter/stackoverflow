# Is there a way to create qml filedialog with specific localization settings?

- **Question:** [stackoverflow.com/q/75067972](https://stackoverflow.com/questions/75067972/is-there-a-way-to-create-qml-filedialog-with-specific-localization-settings) by [Oleg Shindelov](https://stackoverflow.com/users/20972660/oleg-shindelov) · January 2023
- **Tags:** `python` `qt` `qml`
- **My answer:** [answer 75075780](https://stackoverflow.com/questions/75067972/is-there-a-way-to-create-qml-filedialog-with-specific-localization-settings/75075780#75075780) · accepted · score 1 · January 2023

## Question

The asker (using Python) wants a QML `FileDialog` shown in a language other than the
system language, for example Spanish on an English system. Their own `.qm` files
made with Qt Linguist did not translate all of the dialog's buttons and labels.

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/75067972/is-there-a-way-to-create-qml-filedialog-with-specific-localization-settings).

## My answer

Unfortunately I don't know how to do this with python, but I'm sure it is easy for you to translate it to python. Have a look into [Locating Qt Translations][1].

The translations for all Qt components/widgets are stored in your Qt install. For me the path is `Qt/6.4.0/gcc_64/translations`.

I managed to translate all strings in the `FileDialog` by doing the following.

**main.cpp**

```cpp
#include <QGuiApplication>
#include <QLibraryInfo>
#include <QQmlApplicationEngine>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QTranslator qtTranslator;
    if (qtTranslator.load(QLocale("es"),
                          "qtbase",
                          "_",
                          QLibraryInfo::path(QLibraryInfo::TranslationsPath))) {
        app.installTranslator(&qtTranslator);
    }

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/75067972/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
```

**main.qml**

```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Button {
        anchors.centerIn: parent
        text: qsTr("File Dialog")
        onClicked: fileDialog.open()
    }

    FileDialog { id: fileDialog }
}
```

Keep in mind that if you want to deploy your application you must include the translations in your project via CMake or qmake.

  [1]: https://doc.qt.io/qt-6/internationalization.html#locating-qt-translations

## Code in this folder

The C++ code from the answer. It loads the Spanish `qtbase` translation that ships
with Qt and opens a `FileDialog` from a button.

| File | Contents |
| --- | --- |
| [`CMakeLists.txt`](CMakeLists.txt) | CMake project |
| [`main.cpp`](main.cpp) | Installs the `qtbase_es` translator from `QLibraryInfo::TranslationsPath` |
| [`Main.qml`](Main.qml) | Button that opens the `FileDialog` |

### Build and run

Requires Qt 6.5 or later with these modules: Qt Quick (Qt Quick Dialogs).

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/gcc_64
cmake --build build
./build/appDemo75067972
```
