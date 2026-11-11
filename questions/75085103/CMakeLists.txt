cmake_minimum_required(VERSION 3.16)

project(Demo75085103 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo75085103
    main.cpp
)

qt_add_qml_module(appDemo75085103
    URI Demo75085103
    VERSION 1.0
    QML_FILES Main.qml
)

target_link_libraries(appDemo75085103
    PRIVATE Qt6::Quick
)
