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

#ifndef FUELRECORD_H
#define FUELRECORD_H

// Library includes
#include <QString>

// Application includes
#include "unitsystem.h"
#include "datafield.h"

class Fuelrecord
{
private:
    Datafield date;              /* column 0 */
    Datafield km;                 /* column 1 */
    Datafield trip;               /* column 2 */
    Datafield fill;               /* column 3 */
    Datafield consum;             /* column 4 */
    Datafield price;              /* column 5 */
    Datafield ppl;                /* column 6 */
    Datafield ppt;                /* column 7 */
    Datafield service;            /* column 8 */
    Datafield oil;                /* column 9 */
    Datafield tires;              /* column 10 */
    Datafield notes;             /* column 11 */
    Datafield id;              /* column 12, should be sqlite_int64 */
    UnitSystem unit;
public:
    Fuelrecord(UnitSystem u);

    void setUnitSystem(UnitSystem u);
    UnitSystem getUnitSystem(void);

    void setAllValues(QString Date, double Km,
                      double Trip, double Fill, double Consum, double Price,
                      double Ppl, double Ppt, double Service, double Oil,
                      double Tires, QString Notes, qlonglong Id);

    void setAllValuesUserUnit(QString Date, double Km,
                      double Trip, double Fill, double Consum, double Price,
                      double Ppl, double Ppt, double Service, double Oil,
                      double Tires, QString Notes, qlonglong Id);

    void setDate(QString Date);
    void setKm(double Km);
    void setTrip(double Trip);
    void setFill(double Fill);
    void setConsum(double Consum);
    void setPrice(double Price);
    void setPpl(double Ppl);
    void setPpt(double Ppt);
    void setService(double Service);
    void setOil(double Oil);
    void setTires(double Tires);
    void setNotes(QString Notes);
    void setId(qlonglong Id);

    QVariant getDate(void);
    QVariant getKm(void);
    QVariant getTrip(void);
    QVariant getFill(void);
    QVariant getConsum(void);
    QVariant getPrice(void);
    QVariant getPpl(void);
    QVariant getPpt(void);
    QVariant getService(void);
    QVariant getOil(void);
    QVariant getTires(void);

    QVariant getDateUserUnit(void);
    QVariant getKmUserUnit(void);
    QVariant getTripUserUnit(void);
    QVariant getFillUserUnit(void);
    QVariant getConsumUserUnit(void);
    QVariant getPriceUserUnit(void);
    QVariant getPplUserUnit(void);
    QVariant getPptUserUnit(void);
    QVariant getServiceUserUnit(void);
    QVariant getOilUserUnit(void);
    QVariant getTiresUserUnit(void);
    QVariant getNotes(void);
    QVariant getId(void);
    bool getNotFullFill(void);


};

#endif // FUELRECORD_H
