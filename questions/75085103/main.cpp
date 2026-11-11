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
    view.setSource(QUrl(QStringLiteral("qrc:/qt/qml/Demo75085103/Main.qml")));
    view.show();

    return app.exec();
}

#include "main.moc"
