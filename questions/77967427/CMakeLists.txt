cmake_minimum_required(VERSION 3.16)

project(Demo77967427 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo77967427
    main.cpp
)

qt_add_qml_module(appDemo77967427
    URI Demo77967427
    VERSION 1.0
    QML_FILES
        Main.qml
    SOURCES
        dataobject.cpp dataobject.h
        backend.cpp backend.h
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appDemo77967427 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appDemo77967427
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appDemo77967427
    PRIVATE
    Qt6::Core
    Qt6::Qml
    Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appDemo77967427
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
