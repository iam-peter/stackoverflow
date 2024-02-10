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
    view.setSource(QUrl(u"qrc:/Demo75085103/main.qml"_qs));
    view.show();

    return app.exec();
}

#include "main.moc"
