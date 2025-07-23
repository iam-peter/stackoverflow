cmake_minimum_required(VERSION 3.16)

project(Demo79711085 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Location)

qt_standard_project_setup(REQUIRES 6.8)

file(GLOB OfflineTiles "offline_tiles/*.png")

# Convert absolute paths to relative paths
foreach(_tile ${OfflineTiles})
    file(RELATIVE_PATH _relTile "${CMAKE_SOURCE_DIR}" "${_tile}")
    list(APPEND OfflineTilesRel "${_relTile}")
endforeach()

message(STATUS "OfflineTiles: ${OfflineTilesRel}")

qt_add_executable(appDemo79711085
    main.cpp
    qml.qrc
)

qt_add_resources(appDemo79711085 "app_images"
    PREFIX "/"
    FILES
        ${OfflineTilesRel}
)
qt_add_qml_module(appDemo79711085
    URI OsmOffline
    VERSION 1.0
    QML_FILES main.qml
)

set_target_properties(appDemo79711085 PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appDemo79711085
    PRIVATE Qt6::Quick Qt6::Location)

install(TARGETS appDemo79711085
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
