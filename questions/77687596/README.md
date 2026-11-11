# Return QJSValue from C++ to qml

- **Question:** [stackoverflow.com/q/77687596](https://stackoverflow.com/questions/77687596/return-qjsvalue-from-c-to-qml) by [DJMcMayhem](https://stackoverflow.com/users/3524982/djmcmayhem) · December 2023
- **Tags:** `c++` `qt` `qml`
- **My answer:** [answer 77691235](https://stackoverflow.com/questions/77687596/return-qjsvalue-from-c-to-qml/77691235#77691235) · accepted · score 3 · December 2023

## Question

A C++ `Q_PROPERTY` returns a JavaScript array as a `QJSValue`, which the getter builds with
a local `QJSEngine`, as the `QJSValue` documentation suggests. Reading the property
from QML always gives `undefined`.

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/77687596/return-qjsvalue-from-c-to-qml).

## My answer

The important part to answer your question is written in this [paragraph][1]. Arrays are stored on the heap of the engine they were created with. In your case you have two separate engines. The one that comes from `QQmlApplicationEngine` and the other one that you create in the `test()` function. Both have a heap and are separate from one another, this is why the array is undefined. Primitives aren't stored on the heap that is why `return QJSValue(5)` works in your example.

To solve the issue you could forward the "main" engine to your `MyClass` and use it to create the array.

```cpp
QQmlApplicationEngine engine;

MyClass mc(&engine);
MyClass::registerTypes();
engine.rootContext()->setContextProperty("myClass", &mc);
```

```cpp
class MyClass : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QJSValue test READ test NOTIFY testChanged)

public:
    MyClass(QQmlEngine *engine)
        : m_engine(engine)
    {}

    QJSValue test()
    {
        QJSValue l = m_engine->newArray(5);

        for (int i = 0; i < 5; i++) {
            l.setProperty(i, i);
        }

        return l;
    }

    static void registerTypes()
    {
        qmlRegisterUncreatableType<MyClass>("MyTypes",
                                            1,
                                            0,
                                            "MyClass",
                                            "Creation of MyClass type not supported");
    }

signals:
    void testChanged();

private:
    QQmlEngine *m_engine = nullptr;
};
```

[Here][2] you can find the fully working example.


  [1]: https://doc.qt.io/qt-6/qtqml-integrating-with-js-values-from-cpp.html#primitive-and-managed-values
  [2]: https://github.com/iam-peter/stackoverflow/tree/main/questions/77687596

## Code in this folder

The fully working example linked from the answer. `MyClass` receives the
application's `QQmlEngine` and builds the array with it. `Main.qml` prints
`[0,1,2,3,4]` on startup.

| File | Contents |
| --- | --- |
| [`CMakeLists.txt`](CMakeLists.txt) | CMake project |
| [`main.cpp`](main.cpp) | Passes the engine to `MyClass` and exposes it as `myClass` |
| [`Main.qml`](Main.qml) | Logs `myClass.test` |
| [`MyClass.h`](MyClass.h) | Property returning an array created on the QML engine's heap |

### Build and run

Requires Qt 6.5 or later with these modules: Qt Quick.

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/gcc_64
cmake --build build
./build/appDemo77687596
```
