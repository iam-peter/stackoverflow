#include <backend.h>

Backend::Backend(QObject *parent)
    : QObject{parent}
{
    m_header = "Cpp Backend";
    m_model.append(new DataObject("Cpp"));
    m_model.append(new DataObject("backend"));
    m_model.append(new DataObject("is"));
    m_model.append(new DataObject("great!"));
}

Backend::~Backend()
{
    for (QObject *item : m_model)
        delete item;
}
