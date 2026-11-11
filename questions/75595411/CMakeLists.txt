cmake_minimum_required(VERSION 3.16)

project(Demo75595411 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick ShaderTools)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo75595411
    main.cpp
)

qt_add_qml_module(appDemo75595411
    URI Demo75595411
    VERSION 1.0
    QML_FILES Main.qml
)

qt_add_shaders(appDemo75595411 "shaders"
    PRECOMPILE
    OPTIMIZED
    PREFIX "/qt/qml/Demo75595411"
    FILES
        shaders/blur.frag
        shaders/shadow.frag
)

target_link_libraries(appDemo75595411
    PRIVATE Qt6::Quick
)
