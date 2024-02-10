cmake_minimum_required(VERSION 3.16)

project(Demo75032636 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS Charts Core Gui Qml Quick REQUIRED)

qt_add_executable(appDemo75032636
    main.cpp
    datamodel.cpp
    datamodel.h
)

qt_add_qml_module(appDemo75032636
    URI Demo75032636
    VERSION 1.0
    QML_FILES main.qml
)

set_target_properties(appDemo75032636 PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appDemo75032636
    PRIVATE Qt::Charts Qt::Core Qt::Gui Qt::Qml Qt::Quick)

install(TARGETS appDemo75032636
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
