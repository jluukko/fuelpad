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

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

//-------------------------------------------
// Qml custom elements
//-------------------------------------------
#include "line.h"

//-------------------------------------------
// Application includes
//-------------------------------------------
#include "uiengine.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlContext *root;
    QQmlApplicationEngine engine;

    UiEngine uiEngine;

    qmlRegisterType<Line>("CustomComponents", 1, 0, "Line");

    root = engine.rootContext();

    // From C++ to Qml
    root->setContextProperty("fuelModel", uiEngine.getFuelEntryModel());
    root->setContextProperty("carModel", uiEngine.getCarEntryModel());
    root->setContextProperty("driverModel", uiEngine.getDriverEntryModel());
    root->setContextProperty("alarmTypeModel", uiEngine.getAlarmEntryModel());
    root->setContextProperty("alarmEventModel", uiEngine.getAlarmEventModel());
    root->setContextProperty("statisticsModel", uiEngine.getStatisticsModel());
    root->setContextProperty("applicationData", uiEngine.getApplicationData());

    // Where to find the UI abstraction layer
    engine.addImportPath("qrc:/qml/fuelpad2/android");

    engine.load(QUrl(QStringLiteral("qrc:/qml/fuelpad2/main.qml")));

    return app.exec();
}
