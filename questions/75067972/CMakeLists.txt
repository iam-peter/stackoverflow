cmake_minimum_required(VERSION 3.16)

project(Demo75067972 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo75067972
    main.cpp
)

qt_add_qml_module(appDemo75067972
    URI Demo75067972
    VERSION 1.0
    QML_FILES Main.qml
)

target_link_libraries(appDemo75067972
    PRIVATE Qt6::Quick
)
