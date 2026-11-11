#include "datamodel.h"
#include <QApplication>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickView>
#include <QTimer>

#include <cmath>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    DataModel dataModel;

    QQuickView view;
    QObject::connect(view.engine(), &QQmlEngine::quit, &view, &QWindow::close);
    view.rootContext()->setContextProperty("dataModel", &dataModel);
    view.setTitle(QStringLiteral("QML Chart"));
    view.setSource(QUrl(QStringLiteral("qrc:/qt/qml/Demo75032636/Main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();

    int i = 0;
    QTimer timer;
    QObject::connect(&timer, &QTimer::timeout, &dataModel, [&i, &dataModel]() {
        double y = (1 + sin(i / 10.0)) / 2.0;
        dataModel.addData(QPointF(i++, y));
    });
    timer.start(10);

    return app.exec();
}
