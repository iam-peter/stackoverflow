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

    QQuickView view(QUrl(u"qrc:/Demo75069400/main.qml"_qs));
    view.show();

    QObject *item = view.rootObject();
    MyClass myClass;
    QObject::connect(&myClass, SIGNAL(cppSignal(QString)), item, SLOT(callFromCpp(QString)));

    emit myClass.cppSignal("this is a test");

    return app.exec();
}

#include "main.moc"
