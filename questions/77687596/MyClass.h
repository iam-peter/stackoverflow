#ifndef MYCLASS_H
#define MYCLASS_H

#include <QJSEngine>
#include <QJSValue>
#include <QObject>
#include <QQmlEngine>

class MyClass : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QJSValue test READ test NOTIFY testChanged)

public:
    MyClass(QQmlEngine *engine)
        : m_engine(engine)
    {}

    QJSValue test()
    {
        QJSValue l = m_engine->newArray(5);

        for (int i = 0; i < 5; i++) {
            l.setProperty(i, i);
        }

        return l;
    }

    static void registerTypes()
    {
        qmlRegisterUncreatableType<MyClass>("MyTypes",
                                            1,
                                            0,
                                            "MyClass",
                                            "Creation of MyClass type not supported");
    }

signals:
    void testChanged();

private:
    QQmlEngine *m_engine = nullptr;
};

#endif // MYCLASS_H
