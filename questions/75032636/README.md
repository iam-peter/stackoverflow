# Continuously update a QML LineSeries ChartView with a data model from C++

- **Question:** [stackoverflow.com/q/75032636](https://stackoverflow.com/questions/75032636/continuously-update-a-qml-lineseries-chartview-with-a-data-model-from-c) by [MaskedAfrican](https://stackoverflow.com/users/8716544/maskedafrican) · January 2023
- **Tags:** `c++` `qt` `qml` `qabstractitemmodel`
- **My answer:** [answer 75034525](https://stackoverflow.com/questions/75032636/continuously-update-a-qml-lineseries-chartview-with-a-data-model-from-c/75034525#75034525) · accepted · score 2 · January 2023

## Question

A QML `ChartView` with a `LineSeries` is fed by a C++ `QAbstractTableModel` through a
`VXYModelMapper`, and a worker thread appends a point every 10 ms. The application
slows down and eventually crashes. When the model is capped at 500 points by erasing
the first point inside `beginInsertRows()`/`endInsertRows()`, the chart stops updating
after the 500th point.

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/75032636/continuously-update-a-qml-lineseries-chartview-with-a-data-model-from-c).

## My answer

Instead of `beginInsertRows()` and `endInsertRows()` I've used `beginResetModel()` and `endResetModel()` which works. I assume the range for the `beginInsertRows()` is wrong and it doesn't send an update anymore, so it stops drawing. You would probably also need to call `beginRemoveRows()` I would stick with a full reset.

```cpp
void DataModel::addData(const QPointF &point)
{
    beginResetModel();

    if (m_data.size() == 500) {
        m_data.pop_front();
        emit xMinChanged();
    }

    m_data.push_back(point);
    emit xMaxChanged();

    endResetModel();
}
```

[![enter image description here][1]][1]


----------


**Edit:** This will also work.

```cpp
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
```

  [1]: https://i.sstatic.net/7XEn1.gif

## Code in this folder

The model uses the second variant from the answer: `beginRemoveRows()` for the oldest
point, then `beginInsertRows()` for the new one. A `QTimer` in `main.cpp` generates a
sine wave instead of a worker thread.

| File | Contents |
| --- | --- |
| [`CMakeLists.txt`](CMakeLists.txt) | CMake project |
| [`datamodel.cpp`](datamodel.cpp) | Model implementation, keeps the latest 500 points |
| [`datamodel.h`](datamodel.h) | Table model with `xMin`/`xMax` properties for the axis range |
| [`main.cpp`](main.cpp) | Application entry point |
| [`Main.qml`](Main.qml) | `ChartView`, axes and `VXYModelMapper` |

### Build and run

Requires Qt 6.5 or later with these modules: Qt Quick, Qt Charts.

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/gcc_64
cmake --build build
./build/appDemo75032636
```
