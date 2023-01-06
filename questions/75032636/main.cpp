#include "datamodel.h"
#include <QApplication>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickView>
#include <QTimer>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    DataModel dataModel;

    QQuickView view;
    QObject::connect(view.engine(), &QQmlEngine::quit, &view, &QWindow::close);
    view.rootContext()->setContextProperty("dataModel", &dataModel);
    view.setTitle(QStringLiteral("QML Chart"));
    view.setSource(QUrl(u"qrc:/75032636/main.qml"_qs));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();

    int i = 0;
    QTimer *timer = new QTimer();
    QObject::connect(timer, &QTimer::timeout, &dataModel, [&i, &dataModel]() {
        double y = (1 + sin(i / 10.0)) / 2.0;
        dataModel.addData(QPointF(i++, y));
    });
    timer->start(10);

    return app.exec();
}
