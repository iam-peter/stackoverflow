#ifndef DATAOBJECT_H
#define DATAOBJECT_H

#include <QObject>
#include "qqmlintegration.h"

class DataObject : public QObject
{
    QML_ELEMENT
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)

public:
    DataObject(QObject *parent = nullptr);
    DataObject(QString name, QObject *parent = nullptr);

    QString name() const;
    void setName(const QString &name);

signals:
    void nameChanged();

private:
    QString m_name;
};

#endif // DATAOBJECT_H
