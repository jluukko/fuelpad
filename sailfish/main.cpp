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

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>

//-------------------------------------------
// Application includes
//-------------------------------------------
#include "uiengine.h"

int main(int argc, char *argv[])
{
    QGuiApplication *app = SailfishApp::application(argc, argv);
    QQuickView *view = SailfishApp::createView();

    UiEngine uiEngine;

    // From C++ to Qml
    view->rootContext()->setContextProperty("fuelModel", uiEngine.getFuelEntryModel());
    view->rootContext()->setContextProperty("carModel", uiEngine.getCarEntryModel());
    view->rootContext()->setContextProperty("driverModel", uiEngine.getDriverEntryModel());
    view->rootContext()->setContextProperty("alarmTypeModel", uiEngine.getAlarmEntryModel());
    view->rootContext()->setContextProperty("alarmEventModel", uiEngine.getAlarmEventModel());
    view->rootContext()->setContextProperty("statisticsModel", uiEngine.getStatisticsModel());
    view->rootContext()->setContextProperty("applicationData", uiEngine.getApplicationData());

    view->engine()->addImportPath("qml/fuelpad2/sailfish");
    qDebug("qml import path: %s",view->engine()->importPathList().join(":").toStdString().c_str());

    view->setSource(SailfishApp::pathTo("qml/fuelpad2/main.qml"));
    view->showFullScreen();

    return app->exec();
}
