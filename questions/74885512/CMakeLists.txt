cmake_minimum_required(VERSION 3.16)

project(Demo74885512 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Location)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo74885512
    main.cpp
)

qt_add_qml_module(appDemo74885512
    URI Demo74885512
    VERSION 1.0
    QML_FILES Main.qml
)

target_link_libraries(appDemo74885512
    PRIVATE Qt6::Quick Qt6::Location
)
