cmake_minimum_required(VERSION 3.16)

project(Demo76291145 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo76291145
    main.cpp
)

qt_add_qml_module(appDemo76291145
    URI Demo76291145
    VERSION 1.0
    QML_FILES Main.qml
)

target_link_libraries(appDemo76291145
    PRIVATE Qt6::Quick
)
