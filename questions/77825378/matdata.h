#ifndef MATDATA_H
#define MATDATA_H

#include <QSurfaceDataProxy>

class MatData : public QSurfaceDataProxy
{
    Q_OBJECT
public:
    MatData(QObject *parent = nullptr);

private:
    QSurfaceDataArray *m_dataArray = nullptr;
};

#endif // MATDATA_H
