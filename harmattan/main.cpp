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

//-------------------------------------------
// Application includes
//-------------------------------------------
#include "uiengine.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QmlApplicationViewer viewer;

    UiEngine uiEngine;

    qmlRegisterType<Line>("CustomComponents", 1, 0, "Line");

    // From C++ to Qml
    viewer.rootContext()->setContextProperty("fuelModel", uiEngine.getFuelEntryModel());
    viewer.rootContext()->setContextProperty("carModel", uiEngine.getCarEntryModel());
    viewer.rootContext()->setContextProperty("driverModel", uiEngine.getDriverEntryModel());
    viewer.rootContext()->setContextProperty("alarmTypeModel", uiEngine.getAlarmEntryModel());
    viewer.rootContext()->setContextProperty("alarmEventModel", uiEngine.getAlarmEventModel());
    viewer.rootContext()->setContextProperty("statisticsModel", uiEngine.getStatisticsModel());
    viewer.rootContext()->setContextProperty("applicationData", uiEngine.getApplicationData());

    // Where to find the UI abstraction layer
    viewer.addImportPath("qml/fuelpad2/harmattan");
    qDebug("qml import path: %s",viewer.engine()->importPathList().join(":").toStdString().c_str());
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);

    // qml source
    viewer.setMainQmlFile(QLatin1String("qml/fuelpad2/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
