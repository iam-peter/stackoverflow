cmake_minimum_required(VERSION 3.16)

project(Demo75060420 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick LinguistTools REQUIRED)

qt_add_executable(appDemo75060420
    main.cpp
)

qt_add_qml_module(appDemo75060420
    URI Demo75060420
    VERSION 1.0
    QML_FILES main.qml
)

qt_add_translations(appDemo75060420
    TS_FILES locale_en.ts locale_de.ts
    QM_FILES_OUTPUT_VARIABLE qm_files)

set_target_properties(appDemo75060420 PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appDemo75060420
    PRIVATE Qt6::Quick)

install(TARGETS appDemo75060420
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
