cmake_minimum_required(VERSION 3.16)

project(77825378 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIR})

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick DataVisualization)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(app77825378
    main.cpp
)

qt_add_qml_module(app77825378
    URI 77825378
    VERSION 1.0
    QML_FILES Main.qml
    SOURCES matdata.h matdata.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(app77825378 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.app77825378
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(app77825378
    PRIVATE Qt6::Quick Qt6::DataVisualization
    ${OpenCV_LIBS}
)

include(GNUInstallDirs)
install(TARGETS app77825378
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
