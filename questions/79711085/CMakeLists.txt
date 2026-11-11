cmake_minimum_required(VERSION 3.16)

project(Demo79711085 LANGUAGES CXX)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick Location)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appDemo79711085
    main.cpp
)

# Embed the pre-rendered tiles as :/offline_tiles/<tile>.png
file(GLOB offline_tiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "offline_tiles/*.png")
qt_add_resources(appDemo79711085 "offline_tiles"
    PREFIX "/"
    FILES ${offline_tiles}
)

qt_add_qml_module(appDemo79711085
    URI Demo79711085
    VERSION 1.0
    QML_FILES Main.qml
)

target_link_libraries(appDemo79711085
    PRIVATE Qt6::Quick Qt6::Location
)
