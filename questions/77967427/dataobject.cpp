#include "dataobject.h"

DataObject::DataObject(QObject *parent)
    : QObject(parent)
{}

DataObject::DataObject(QString name, QObject *parent)
    : QObject(parent)
    , m_name(name)
{}
