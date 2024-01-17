#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <matdata.h>

int main(int argc, char *argv[])
{
    qmlRegisterType<MatData>("CustomProxy", 1, 0, "MatData");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("77825378", "Main");

    return app.exec();
}
