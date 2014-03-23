# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = fuelpad2-sailfish

CONFIG += sailfishapp

SOURCES += sailfish/main.cpp \
    sailfish/line.cpp

HEADERS += sailfish/line.h

INCLUDEPATH += sailfish

#QT += positioning

include(engine/engine.pri)

OTHER_FILES += qml/fuelpad2/AboutDialog.qml \
    qml/fuelpad2/AddAlarmEventDialog.qml \
    qml/fuelpad2/AddAlarmTypeDialog.qml \
    qml/fuelpad2/AddCarDialog.qml \
    qml/fuelpad2/AddDriverDialog.qml \
    qml/fuelpad2/AddFuelEntryDialog.qml \
    qml/fuelpad2/AlarmEventPage.qml \
    qml/fuelpad2/AlarmTypePage.qml \
    qml/fuelpad2/CommonFuncs.js \
    qml/fuelpad2/CommonUnits.js \
    qml/fuelpad2/DeleteCarDialog.qml \
    qml/fuelpad2/DeleteDriverDialog.qml \
    qml/fuelpad2/DeleteFuelEntryDialog.qml \
    qml/fuelpad2/DialogStatus.js \
    qml/fuelpad2/DrivingLogPage.qml \
    qml/fuelpad2/ElementText.qml \
    qml/fuelpad2/FuelViewPage.qml \
    qml/fuelpad2/LabelText.qml \
    qml/fuelpad2/MainPage.qml \
    qml/fuelpad2/main.qml \
    qml/fuelpad2/ManageCarsPage.qml \
    qml/fuelpad2/ManageDriversPage.qml \
    qml/fuelpad2/MyDialog.qml \
    qml/fuelpad2/MyLabelStyleTitle.qml \
    qml/fuelpad2/PageHeader.qml \
    qml/fuelpad2/Plot.qml \
    qml/fuelpad2/RemindersPage.qml \
    qml/fuelpad2/SelectLocationPage.qml \
    qml/fuelpad2/SettingsPage.qml \
    qml/fuelpad2/StatisticsPage.qml \
    qml/fuelpad2/TouchSelector.qml \
    qml/fuelpad2/UIConstants.js \
    rpm/fuelpad2-sailfish.spec \
    rpm/fuelpad2-sailfish.yaml \
    fuelpad2-sailfish.desktop
