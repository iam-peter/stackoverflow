cmake_minimum_required(VERSION 3.16)

project(Demo76685924 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Location)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo76685924
    main.cpp
)

qt_add_qml_module(appDemo76685924
    URI Demo76685924
    VERSION 1.0
    QML_FILES Main.qml
)

target_link_libraries(appDemo76685924
    PRIVATE Qt6::Quick Qt6::Location
)
