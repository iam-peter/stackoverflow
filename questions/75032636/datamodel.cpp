#include "datamodel.h"
#include <QSize>

DataModel::DataModel() : m_data(), m_xMin(0), m_xMax(0) {}

int DataModel::rowCount(const QModelIndex &parent) const
{
    return m_data.size();
}

int DataModel::columnCount(const QModelIndex &parent) const
{
    return 2;
}

QVariant DataModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || role != Qt::DisplayRole)
        return QVariant();

    const QPointF p = m_data[index.row()];

    if (index.column() == 0)
        return p.x();

    return p.y();
}

QVariant DataModel::headerData(int /* section */, Qt::Orientation /* orientation */, int role) const
{
    if (role == Qt::SizeHintRole)
        return QSize(1, 1);
    return QVariant();
}

QHash<int, QByteArray> DataModel::roleNames() const
{
    static QHash<int, QByteArray> roleNames{{ValueRole, "value"}};
    return roleNames;
}

void DataModel::addData(const QPointF &point)
{
    if (m_data.size() == 500) {
        beginRemoveRows(QModelIndex(), 0, 0);
        m_data.pop_front();
        endRemoveRows();
        emit xMinChanged();
    }

    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_data.push_back(point);
    endInsertRows();
    emit xMaxChanged();
}
