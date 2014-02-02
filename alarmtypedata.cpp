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

#include "alarmtypedata.h"

AlarmtypeData::AlarmtypeData()
{
}

void AlarmtypeData::setId(qlonglong Id)
{
    id = Id;
}

qlonglong AlarmtypeData::getId(void)
{
    return id;
}

void AlarmtypeData::setShortDesc(QString desc)
{
    shortdesc = desc;
}

QString AlarmtypeData::getShortDesc(void)
{
    return shortdesc;
}

void AlarmtypeData::setLongDesc(QString desc)
{
    longdesc = desc;
}

QString AlarmtypeData::getLongDesc(void)
{
    return longdesc;
}

void AlarmtypeData::setDistance(quint32 dist)
{
    distance = dist;
}

quint32 AlarmtypeData::getDistance(void)
{
    return distance;
}

void AlarmtypeData::setInterval(quint32 inter)
{
    interval = inter;
}

quint32 AlarmtypeData::getInterval(void)
{
    return interval;
}
