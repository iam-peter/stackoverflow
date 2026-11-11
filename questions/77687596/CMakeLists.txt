cmake_minimum_required(VERSION 3.16)

project(Demo77687596 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo77687596
    main.cpp
)

qt_add_qml_module(appDemo77687596
    URI Demo77687596
    VERSION 1.0
    QML_FILES Main.qml
    SOURCES MyClass.h
)

target_link_libraries(appDemo77687596
    PRIVATE Qt6::Quick
)
