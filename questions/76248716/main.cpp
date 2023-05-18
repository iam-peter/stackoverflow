#include <QApplication>
#include <QQuickWidget>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QQuickWidget *view = new QQuickWidget();
    view->setSource(url);
    view->show();

    return app.exec();
}
