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

#include "uiengine.h"

#include <QDir>

#include <qplatformdefs.h> // MEEGO_EDITION_HARMATTAN

#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
#include <QStandardPaths>
#endif

UiEngine::UiEngine(void)
{
    dataBase = &sqliteDatabase;
    geoCode = &nominatimGeoCode;

#ifdef MEEGO_EDITION_HARMATTAN
#warning "Compiling for harmattan"
    QDir dbFileDir = QDir("/home/user");
    dbFileDir.mkdir(QString(".fuelpad"));
    dataBase->setFileName((dbFileDir.path() + QString("/fuelpad.db")).toStdString());
#else
    QString homeLocation = QStandardPaths::locate(QStandardPaths::GenericDataLocation, QString(), QStandardPaths::LocateDirectory);
    dataBase->setFileName((homeLocation + QString("/fuelpad.db")).toStdString());
    qDebug("home location = %s", homeLocation.toStdString().c_str());
#endif
    dataBase->openConnection();

    uiWrapper = new UiWrapper(dataBase, geoCode);
    fuelEntryModel = uiWrapper->getFuelEntryModel();
    carEntryModel = uiWrapper->getCarEntryModel();
    driverEntryModel = uiWrapper->getDriverEntryModel();
    alarmEntryModel = uiWrapper->getAlarmEntryModel();
    alarmEventModel = uiWrapper->getAlarmEventModel();
    statisticsModel = uiWrapper->getStatisticsModel();
    carStatisticsModel = uiWrapper->getCarStatisticsModel();

}

UiEngine::~UiEngine(void)
{
    delete uiWrapper;
}

UiWrapper* UiEngine::getApplicationData(void)
{
    return uiWrapper;
}

MySortFilterProxyModel* UiEngine::getFuelEntryModel(void)
{
    return fuelEntryModel;
}

RoleItemModel* UiEngine::getCarEntryModel(void)
{
    return carEntryModel;
}

RoleItemModel* UiEngine::getDriverEntryModel(void)
{
    return driverEntryModel;
}

MySortFilterProxyModel* UiEngine::getAlarmEntryModel(void)
{
    return alarmEntryModel;
}

MySortFilterProxyModel* UiEngine::getAlarmEventModel(void)
{
    return alarmEventModel;
}

MySortFilterProxyModel* UiEngine::getCarStatisticsModel(void)
{
    return carStatisticsModel;
}

PlotDataModel* UiEngine::getStatisticsModel(void)
{
    return statisticsModel;
}
