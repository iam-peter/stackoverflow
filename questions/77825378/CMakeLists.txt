cmake_minimum_required(VERSION 3.16)

project(Demo77825378 LANGUAGES CXX)

find_package(OpenCV REQUIRED)
find_package(Qt6 6.5 REQUIRED COMPONENTS Quick DataVisualization)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo77825378
    main.cpp
)

qt_add_qml_module(appDemo77825378
    URI Demo77825378
    VERSION 1.0
    QML_FILES Main.qml
    SOURCES matdata.h matdata.cpp
)

target_link_libraries(appDemo77825378
    PRIVATE Qt6::Quick Qt6::DataVisualization ${OpenCV_LIBS}
)
