TEMPLATE = app

QT += qml quick positioning widgets

SOURCES += android-src/main.cpp \
    android-src/line.cpp

include(engine/engine.pri)

RESOURCES += qml-android.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment-android.pri)

HEADERS += \
    android-src/line.h
