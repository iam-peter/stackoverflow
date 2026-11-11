cmake_minimum_required(VERSION 3.16)

project(Demo77967427 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Qml Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo77967427
    main.cpp
)

qt_add_qml_module(appDemo77967427
    URI Demo77967427
    VERSION 1.0
    QML_FILES Main.qml
    SOURCES dataobject.cpp dataobject.h backend.cpp backend.h
)

target_link_libraries(appDemo77967427
    PRIVATE Qt6::Qml Qt6::Quick
)
