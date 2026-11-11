cmake_minimum_required(VERSION 3.16)

project(Demo75623151 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick ShaderTools)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo75623151
    main.cpp
)

qt_add_qml_module(appDemo75623151
    URI Demo75623151
    VERSION 1.0
    QML_FILES Main.qml
)

qt_add_shaders(appDemo75623151 "shaders"
    PRECOMPILE
    OPTIMIZED
    PREFIX "/qt/qml/Demo75623151"
    FILES
        shaders/blend.frag
)

target_link_libraries(appDemo75623151
    PRIVATE Qt6::Quick
)
