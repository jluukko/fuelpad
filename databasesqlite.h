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

#ifndef DATABASESQLITE_H
#define DATABASESQLITE_H

// Qt library includes
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>

// Application includes
#include "database.h"
#include "unitsystem.h"

class DatabaseSqlite: public Database
{
public:
    DatabaseSqlite(void);
    ~DatabaseSqlite(void);

    bool isOpen(void);
    bool openConnection(void);
    void closeConnection(void);

    void setCurrentCar(int id);
    CarData getCurrentCar(void);
    void setCurrentDriver(int id);
    DriverData getCurrentDriver(void);

    // Record querying
    bool initRecordQuery(void);
    void resetRecordQuery(void);
    bool stepRecordQuery(void);
    Fuelrecord *getValuesRecordQuery(UnitSystem unit);
    Fuelrecord *queryOneRecord(qlonglong id, UnitSystem unit);

    // Adding record
    qlonglong addNewRecord(Fuelrecord &record, bool notFull);
    bool getNextFullFill(float km, Fuelrecord &record);
    bool getPrevNotFullData(float km, Fuelrecord &record);

    // Updating record
    qlonglong updateRecord(Fuelrecord &record, bool notFull);

    // Removing record
    qlonglong deleteRecord(qlonglong id);

    // Querying simple statistics
    dbtimespan getTotalKm(UnitSystem unit);

    // Querying monthly statistics
    bool getMonthlyData(int year, UnitSystem unit, vector<int> &month,
                        vector<double> &fill, vector<double> &trip,
                        vector<double> &consum, vector<double> &ppl);

    // Add a new driver
    bool addDriver(string fullname, string nickname);

    // Add a new car
    bool addCar(string mark, string model, string year, string regist, string notes, quint8 fueltype);

    vector<CarData> getCarData(void);
    vector<DriverData> getDriverData(void);

private:
    bool create_database(void);
    bool prepare_queries(void);
    bool unprepare_queries(void);

    // Car and driver data from database
    CarData *getCarDataFromDB(qlonglong id);
    DriverData *getDriverDataFromDB(qlonglong id);

    qlonglong internalSetRecord(Fuelrecord &record, bool notFull);
    bool internalUpdateRecord(Fuelrecord record);

    bool createFillView(void);
    bool dropFillView(void);

    QSqlDatabase db;

    // Prepared SQL queries

    // Statements with a ready implementation
    QSqlQuery *ppStmtRecords;
    QSqlQuery *ppStmtOneRecord;
    QSqlQuery *ppStmtOneCar;
    QSqlQuery *ppStmtMonthlyData;
    QSqlQuery *ppStmtCar;
    QSqlQuery *ppStmtOneDriver;
    QSqlQuery *ppStmtDriver;
    QSqlQuery *ppStmtNextFull;
    QSqlQuery *ppStmtPrevFull;
    QSqlQuery *ppStmtAddRecord;
    QSqlQuery *ppStmtUpdateRecord;
    QSqlQuery *ppStmtDeleteRecord;
    QSqlQuery *ppStmtGetKmOverall;
    QSqlQuery *ppStmtGetKmLastMonth;
    QSqlQuery *ppStmtAddDriver;
    QSqlQuery *ppStmtAddCar;

    // Statements without a ready implementation
    QSqlQuery *ppStmtCurCar;
    QSqlQuery *ppStmtUpdateDriver;
    QSqlQuery *ppStmtUpdateCar;
    QSqlQuery *ppStmtExport;
    QSqlQuery *ppStmtExportCar;
    QSqlQuery *ppStmtGetReport;
    QSqlQuery *ppStmtAddAlarmtype;
    QSqlQuery *ppStmtGetAlarmtype;
    QSqlQuery *ppStmtGetOneAlarmtype;
    QSqlQuery *ppStmtUpdateAlarmtype;
    QSqlQuery *ppStmtAddEvent;
    QSqlQuery *ppStmtGetEvents;
    QSqlQuery *ppStmtGetOneEvent;
    QSqlQuery *ppStmtDeleteEvent;
    QSqlQuery *ppStmtDeleteEventwithRecordid;
    QSqlQuery *ppStmtUpdateEvent;

    QSqlQuery *ppStmtGetYears;
    QSqlQuery *ppStmtAddLog;
    QSqlQuery *ppStmtDeleteTrip;
    QSqlQuery *ppStmtUpdateTrip;
    QSqlQuery *ppStmtLogs;
    QSqlQuery *ppStmtOneTrip;
    QSqlQuery *ppStmtAddLocationAlias;
    QSqlQuery *ppStmtFindNearestLocationAlias;
    QSqlQuery *ppStmtLocations;
    QSqlQuery *ppStmtUpdateLocation;
    QSqlQuery *ppStmtDeleteLocation;

    QSqlQuery *ppStmtGetKmLastYear;

};

#endif // DATABASESQLITE_H
