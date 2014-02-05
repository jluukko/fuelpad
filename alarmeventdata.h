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

#ifndef ALARMEVENTDATA_H
#define ALARMEVENTDATA_H

#include <QtGlobal>
#include <QString>

class AlarmeventData
{
public:
    AlarmeventData();

    void setId(qlonglong Id);
    qlonglong getId(void);

    void setCarId(qlonglong Id);
    qlonglong getCarId(void);

    void setRecordId(qlonglong Id);
    qlonglong getRecordId(void);

    void setDate(QString day);
    QString getDate(void);

    void setKm(double kilom);
    double getKm(void);

private:
    // Database id: "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    qlonglong id;

    // Car id to which car this event belongs to
    qlonglong carId;

    // Link to record in fuel database
    qlonglong recordId;

    // Date when event occured
    QString date;

    // Km when event occured
    double km;
};

#endif // ALARMEVENTDATA_H
