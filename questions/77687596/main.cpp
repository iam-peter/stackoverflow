#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "MyClass.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    MyClass mc(&engine);
    MyClass::registerTypes();
    engine.rootContext()->setContextProperty("myClass", &mc);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);
    engine.loadFromModule("Demo77687596", "Main");

    return app.exec();
}
