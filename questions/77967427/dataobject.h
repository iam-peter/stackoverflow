#ifndef DATAOBJECT_H
#define DATAOBJECT_H

#include <QObject>
#include "qqmlintegration.h"

class DataObject : public QObject
{
    QML_ELEMENT
    Q_OBJECT
    Q_PROPERTY(QString name MEMBER m_name NOTIFY nameChanged)

public:
    DataObject(QObject *parent = nullptr);
    DataObject(QString name, QObject *parent = nullptr);

signals:
    void nameChanged();

private:
    QString m_name;
};

#endif // DATAOBJECT_H
