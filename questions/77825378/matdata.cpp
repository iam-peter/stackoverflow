#include "matdata.h"

#include "opencv2/opencv.hpp"

MatData::MatData(QObject *parent)
    : QSurfaceDataProxy(parent)
{
    // Create a cv::Mat to be used as surface
    cv::Mat test(20, 20, CV_32F);
    cv::Mat mean = cv::Mat::zeros(1, 1, CV_32F);
    cv::Mat sigma = cv::Mat::ones(1, 1, CV_32F);
    sigma.at<float>(0, 0, 0) = 10;

    cv::RNG rng;
    rng.fill(test, cv::RNG::NORMAL, mean, sigma);

    cv::Mat mat;
    blur(test, mat, cv::Size(5, 5));

    m_dataArray = new QSurfaceDataArray;
    m_dataArray->reserve(mat.rows);

    for (int i = 0; i < mat.rows; i++) {
        QSurfaceDataRow *newProxyRow = new QSurfaceDataRow(mat.cols);
        m_dataArray->append(newProxyRow);

        for (int j = 0; j < mat.cols; j++) {
            QSurfaceDataItem &item = (*newProxyRow)[j];
            item.setPosition(QVector3D(i, mat.at<float>(i, j), j));

            // https://bugreports.qt.io/browse/QTBUG-103965
            auto tmp = (*newProxyRow)[j];
            tmp.setPosition(QVector3D(tmp.z(), tmp.y(), tmp.x()));
            (*newProxyRow)[j] = tmp;
        }
    }

    resetArray(m_dataArray);
}
