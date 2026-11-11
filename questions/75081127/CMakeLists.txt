cmake_minimum_required(VERSION 3.16)

project(Demo75081127 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo75081127
    main.cpp
)

qt_add_qml_module(appDemo75081127
    URI Demo75081127
    VERSION 1.0
    QML_FILES Main.qml
)

target_link_libraries(appDemo75081127
    PRIVATE Qt6::Quick
)
