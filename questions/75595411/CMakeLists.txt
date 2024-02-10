cmake_minimum_required(VERSION 3.16)

project(Demo75595411 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick ShaderTools REQUIRED)

qt_add_executable(appDemo75595411
    main.cpp
)

qt_add_qml_module(appDemo75595411
    URI Demo75595411
    VERSION 1.0
    QML_FILES main.qml
)

qt_add_shaders(appDemo75595411 "appDemo75595411_shaders"
    PRECOMPILE
    OPTIMIZED
    PREFIX
        "/Demo75595411"
    FILES
        "shaders/blur.frag"
        "shaders/shadow.frag"
)

set_target_properties(appDemo75595411 PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appDemo75595411
    PRIVATE Qt6::Quick)

install(TARGETS appDemo75595411
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
