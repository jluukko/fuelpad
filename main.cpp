/*
 * This file is part of Fuelpad.
 *
 * Copyright (C) 2007-2012 Julius Luukko <julle.luukko@quicknet.inet.fi>
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
#include <QtDeclarative/QDeclarativeView>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeContext>
#include <QGraphicsObject>
#include <QDir>

#include <qplatformdefs.h> // MEEGO_EDITION_HARMATTAN

#include <iostream>

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

QString adjustPath(const QString &path)
{
#ifdef Q_OS_UNIX
#ifdef Q_OS_MAC
    if (!QDir::isAbsolutePath(path))
        return QCoreApplication::applicationDirPath()
                + QLatin1String("/../Resources/") + path;
#else
    QString pathInInstallDir;
    const QString applicationDirPath = QCoreApplication::applicationDirPath();
    pathInInstallDir = QString::fromAscii("%1/../%2").arg(applicationDirPath, path);

    if (QFileInfo(pathInInstallDir).exists())
        return pathInInstallDir;
#endif
#endif
    return path;
}


Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QDeclarativeView view;
//    QObject *object;

    qmlRegisterType<Line>("CustomComponents", 1, 0, "Line");

    DatabaseSqlite sqliteDatabase;
    Database *dataBase;

    dataBase = &sqliteDatabase;

    GeocodeNominatim nominatimGeoCode;
    Geocode *geoCode;

    geoCode = &nominatimGeoCode;

#ifdef MEEGO_EDITION_HARMATTAN
#warning "Compiling for harmattan"
    QDir dbFileDir = QDir("/home/user");
    dbFileDir.mkdir(QString(".fuelpad"));
    dataBase->setFileName((dbFileDir.path() + QString("/fuelpad.db")).toStdString());
#else
    dataBase->setFileName("fuelpad.db");
#endif
    dataBase->openConnection();

    dataBase->setCurrentCar(2);
    dataBase->setCurrentDriver(1);

    UiWrapper uiWrapper(dataBase, geoCode);
    MySortFilterProxyModel *fuelEntryModel = uiWrapper.getFuelEntryModel();
    RoleItemModel *carEntryModel = uiWrapper.getCarEntryModel();
    RoleItemModel *driverEntryModel = uiWrapper.getDriverEntryModel();
    MySortFilterProxyModel *alarmEntryModel = uiWrapper.getAlarmEntryModel();
    MySortFilterProxyModel *alarmEventModel = uiWrapper.getAlarmEventModel();

    // From C++ to Qml
    view.rootContext()->setContextProperty("fuelModel", fuelEntryModel);
    view.rootContext()->setContextProperty("carModel", carEntryModel);
    view.rootContext()->setContextProperty("driverModel", driverEntryModel);
    view.rootContext()->setContextProperty("alarmTypeModel", alarmEntryModel);
    view.rootContext()->setContextProperty("alarmEventModel", alarmEventModel);
    view.rootContext()->setContextProperty("applicationData", &uiWrapper);

    // qml source
    view.setSource(QUrl::fromLocalFile(adjustPath("qml/fuelpad2/main.qml")));

    // qml quit signal to c++ signal?
    QObject::connect(view.engine(), SIGNAL(quit()), &app, SLOT(quit()));

    view.setResizeMode(QDeclarativeView::SizeRootObjectToView);

    // show the qml view
#if defined(Q_OS_SYMBIAN) || defined(MEEGO_EDITION_HARMATTAN) || defined(Q_WS_SIMULATOR)
    view.showFullScreen();
#elif defined(Q_WS_MAEMO_5)
    view.showMaximized();
#else
    view.show();
#endif

    return app.exec();
}
