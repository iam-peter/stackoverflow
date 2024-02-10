#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <dataobject.h>

class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString header MEMBER m_header NOTIFY headerChanged)
    Q_PROPERTY(QList<QObject *> model READ model NOTIFY modelChanged)
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit Backend(QObject *parent = nullptr);
    virtual ~Backend() override;

    QList<QObject *> model();

signals:
    void headerChanged();
    void modelChanged();

private:
    QString m_header;
    QList<QObject *> m_model;
};

#endif // BACKEND_H
