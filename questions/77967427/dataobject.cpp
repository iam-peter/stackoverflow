#include "dataobject.h"

DataObject::DataObject(QObject *parent)
    : QObject(parent)
{}

DataObject::DataObject(QString name, QObject *parent)
    : QObject(parent)
    , m_name(name)
{}

QString DataObject::name() const
{
    return m_name;
}

void DataObject::setName(const QString &name)
{
    if (m_name == name)
        return;

    m_name = name;
    emit nameChanged();
}
