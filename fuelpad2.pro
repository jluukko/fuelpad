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
    engine/database.cpp \
    engine/databasesqlite.cpp \
    engine/fuelrecord.cpp \
    engine/datafield.cpp \
    engine/unitsystem.cpp \
    engine/cardata.cpp \
    engine/userconfig.cpp \
    engine/driverdata.cpp \
    engine/roleitemmodel.cpp \
    engine/uiwrapper.cpp \
    engine/mysortfilterproxymodel.cpp \
    engine/line.cpp \
    engine/alarmtypedata.cpp \
    engine/alarmeventdata.cpp \
    engine/geocode.cpp \
    engine/geocodenominatim.cpp \
    engine/plotdatamodel.cpp
HEADERS += \
    engine/database.h \
    engine/databasesqlite.h \
    engine/fuelrecord.h \
    engine/datafield.h \
    engine/unitsystem.h \
    engine/cardata.h \
    engine/userconfig.h \
    engine/driverdata.h \
    engine/roleitemmodel.h \
    engine/uiwrapper.h \
    engine/mysortfilterproxymodel.h \
    engine/line.h \
    engine/alarmtypedata.h \
    engine/alarmeventdata.h \
    engine/geocode.h \
    engine/geocodenominatim.h \
    engine/plotdatamodel.h
FORMS +=
QT += sql \
    declarative \
    network \
    xml

INCLUDEPATH += engine

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
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
