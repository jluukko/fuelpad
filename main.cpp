/*
 * This file is part of Fuelpad.
 *
 * Copyright (C) 2007-2012,2014 Julius Luukko <julle.luukko@quicknet.inet.fi>
 *
 * Fuelpad is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Fuelpad is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Fuelpad.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include <QGraphicsObject>
#include <QDir>

#include <qplatformdefs.h> // MEEGO_EDITION_HARMATTAN

//-------------------------------------------
// Qml custom elements
//-------------------------------------------
#include "line.h"

//-------------------------------------------
// Application includes
//-------------------------------------------
#include "uiwrapper.h"
#include "database.h"
#include "databasesqlite.h"
#include "geocode.h"
#include "geocodenominatim.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QmlApplicationViewer viewer;

    qmlRegisterType<Line>("CustomComponents", 1, 0, "Line");

    //-------------------------------------------
    // Setup database
    //-------------------------------------------
    DatabaseSqlite sqliteDatabase;
    Database *dataBase;

    dataBase = &sqliteDatabase;

#ifdef MEEGO_EDITION_HARMATTAN
#warning "Compiling for harmattan"
    QDir dbFileDir = QDir("/home/user");
    dbFileDir.mkdir(QString(".fuelpad"));
    dataBase->setFileName((dbFileDir.path() + QString("/fuelpad.db")).toStdString());
#else
    dataBase->setFileName("fuelpad.db");
#endif
    dataBase->openConnection();

    //-------------------------------------------
    // Setup geocoding: use OpenStreetMap Nominatim
    //-------------------------------------------
    GeocodeNominatim nominatimGeoCode;
    Geocode *geoCode;

    geoCode = &nominatimGeoCode;

    //-------------------------------------------
    // Setup C++ UI wrapper and expose its data to QML
    //-------------------------------------------
    UiWrapper uiWrapper(dataBase, geoCode);
    MySortFilterProxyModel *fuelEntryModel = uiWrapper.getFuelEntryModel();
    RoleItemModel *carEntryModel = uiWrapper.getCarEntryModel();
    RoleItemModel *driverEntryModel = uiWrapper.getDriverEntryModel();
    MySortFilterProxyModel *alarmEntryModel = uiWrapper.getAlarmEntryModel();
    MySortFilterProxyModel *alarmEventModel = uiWrapper.getAlarmEventModel();
    PlotDataModel *statisticsModel = uiWrapper.getStatisticsModel();

    // From C++ to Qml
    viewer.rootContext()->setContextProperty("fuelModel", fuelEntryModel);
    viewer.rootContext()->setContextProperty("carModel", carEntryModel);
    viewer.rootContext()->setContextProperty("driverModel", driverEntryModel);
    viewer.rootContext()->setContextProperty("alarmTypeModel", alarmEntryModel);
    viewer.rootContext()->setContextProperty("alarmEventModel", alarmEventModel);
    viewer.rootContext()->setContextProperty("statisticsModel", statisticsModel);
    viewer.rootContext()->setContextProperty("applicationData", &uiWrapper);

    // Where to find the UI abstraction layer
    viewer.addImportPath("qml/fuelpad2/harmattan");
    qDebug("qml import path: %s",viewer.engine()->importPathList().join(":").toStdString().c_str());
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);

    // qml source
    viewer.setMainQmlFile(QLatin1String("qml/fuelpad2/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
