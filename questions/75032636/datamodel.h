#ifndef DATAMODEL_H
#define DATAMODEL_H

#include <QAbstractTableModel>
#include <QPointF>

class DataModel : public QAbstractTableModel
{
    Q_OBJECT

    Q_PROPERTY(int xMin READ xMin NOTIFY xMinChanged)
    Q_PROPERTY(int xMax READ xMax NOTIFY xMaxChanged)

    enum { ValueRole = Qt::DisplayRole };

public:
    DataModel();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QVariant headerData(int section,
                        Qt::Orientation orientation,
                        int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override;

    void addData(const QPointF &point);

    int xMin() { return m_data.isEmpty() ? 0 : m_data.constFirst().x(); }
    int xMax() { return m_data.isEmpty() ? 0 : m_data.constLast().x(); }

signals:
    void xMinChanged();
    void xMaxChanged();

private:
    QVector<QPointF> m_data;
    int m_xMin;
    int m_xMax;
};

#endif // DATAMODEL_H
