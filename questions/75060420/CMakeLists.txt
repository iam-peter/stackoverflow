cmake_minimum_required(VERSION 3.16)

project(Demo75060420 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick LinguistTools)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDemo75060420
    main.cpp
)

qt_add_qml_module(appDemo75060420
    URI Demo75060420
    VERSION 1.0
    QML_FILES Main.qml
)

# Runs lupdate/lrelease and embeds the .qm files under the :/i18n resource prefix
qt_add_translations(appDemo75060420
    TS_FILES locale_en.ts locale_de.ts
)

target_link_libraries(appDemo75060420
    PRIVATE Qt6::Quick
)
