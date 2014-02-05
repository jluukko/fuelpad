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

#include "alarmeventdata.h"

AlarmeventData::AlarmeventData()
{
}

void AlarmeventData::setId(qlonglong Id)
{
    id = Id;
}

qlonglong AlarmeventData::getId(void)
{
    return id;
}

void AlarmeventData::setCarId(qlonglong Id)
{
    carId = Id;
}

qlonglong AlarmeventData::getCarId(void)
{
    return carId;
}

void AlarmeventData::setRecordId(qlonglong Id)
{
    recordId = Id;
}

qlonglong AlarmeventData::getRecordId(void)
{
    return recordId;
}

void AlarmeventData::setDate(QString day)
{
    date = day;
}

QString AlarmeventData::getDate(void)
{
    return date;
}

void AlarmeventData::setKm(double kilom)
{
    km = kilom;
}

double AlarmeventData::getKm(void)
{
    return km;
}
