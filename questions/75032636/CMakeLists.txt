cmake_minimum_required(VERSION 3.16)

project(Demo75032636 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Charts Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo75032636
    main.cpp
)

qt_add_qml_module(appDemo75032636
    URI Demo75032636
    VERSION 1.0
    QML_FILES Main.qml
    SOURCES datamodel.cpp datamodel.h
)

target_link_libraries(appDemo75032636
    PRIVATE Qt6::Charts Qt6::Quick
)
