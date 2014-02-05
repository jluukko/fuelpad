# Add files and directories to ship with the application 
# by adapting the examples below.
# file1.source = myfile
# dir1.source = mydir
folder_01.source = qml/fuelpad2
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01 # file1 dir1

symbian:TARGET.UID3 = 0xE9B252F5

# Smart Installer package's UID
# This UID is from the protected range 
# and therefore the package will fail to install if self-signed
# By default qmake uses the unprotected range value if unprotected UID is defined for the application
# and 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment
# the following lines and add the respective components to the 
# MOBILITY variable. 
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

SOURCES += main.cpp \
    database.cpp \
    databasesqlite.cpp \
    fuelrecord.cpp \
    datafield.cpp \
    unitsystem.cpp \
    cardata.cpp \
    userconfig.cpp \
    driverdata.cpp \
    roleitemmodel.cpp \
    uiwrapper.cpp \
    mysortfilterproxymodel.cpp \
    line.cpp \
    alarmtypedata.cpp \
    alarmeventdata.cpp
HEADERS += \
    database.h \
    databasesqlite.h \
    fuelrecord.h \
    datafield.h \
    unitsystem.h \
    cardata.h \
    userconfig.h \
    driverdata.h \
    roleitemmodel.h \
    uiwrapper.h \
    mysortfilterproxymodel.h \
    line.h \
    alarmtypedata.h \
    alarmeventdata.h
FORMS +=
QT += sql \
    declarative

# Please do not modify the following two lines. Required for deployment.
include(deployment.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qtc_packaging/debian_fremantle/rules \
    qtc_packaging/debian_fremantle/README \
    qtc_packaging/debian_fremantle/copyright \
    qtc_packaging/debian_fremantle/control \
    qtc_packaging/debian_fremantle/compat \
    qtc_packaging/debian_fremantle/changelog

contains(MEEGO_EDITION,harmattan) {
    icon.files = fuelpad2.png
    icon.path = /usr/share/icons/hicolor/80x80/apps
    INSTALLS += icon
}
