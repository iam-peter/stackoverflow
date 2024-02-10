cmake_minimum_required(VERSION 3.16)

project(Demo77687596 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appDemo77687596
    main.cpp
)

qt_add_qml_module(appDemo77687596
    URI Demo77687596
    VERSION 1.0
    QML_FILES Main.qml
    SOURCES MyClass.h
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appDemo77687596 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appDemo77687596
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appDemo77687596
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appDemo77687596
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
