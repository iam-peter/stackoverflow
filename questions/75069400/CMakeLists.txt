cmake_minimum_required(VERSION 3.16)

project(Demo75069400 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo75069400
    main.cpp
)

qt_add_qml_module(appDemo75069400
    URI Demo75069400
    VERSION 1.0
    QML_FILES Main.qml
)

target_link_libraries(appDemo75069400
    PRIVATE Qt6::Quick
)
