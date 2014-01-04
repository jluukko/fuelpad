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

#include "mysortfilterproxymodel.h"

MySortFilterProxyModel::MySortFilterProxyModel(QObject *parent, const QHash<int, QByteArray> &roleNames) :
    QSortFilterProxyModel(parent)
{
    qDebug("%s",__PRETTY_FUNCTION__);
    setRoleNames(roleNames);
}

bool MySortFilterProxyModel::filterAcceptsRow(int sourceRow,
        const QModelIndex &sourceParent) const
{
//    qDebug("%s",__PRETTY_FUNCTION__);
    return true;
}

bool MySortFilterProxyModel::lessThan(const QModelIndex &left,
                                       const QModelIndex &right) const
{
    QVariant leftData = sourceModel()->data(left);
    QVariant rightData = sourceModel()->data(right);

//    qDebug("%s",__PRETTY_FUNCTION__);

    if (leftData.type() == QVariant::DateTime) {
        return leftData.toDateTime() < rightData.toDateTime();
    }
    else if (leftData.type() == QVariant::Double) {
        return leftData.toDouble() < rightData.toDouble();
    }
    else if (leftData.type() == QVariant::String) {
        return QString::localeAwareCompare(leftData.toString(), rightData.toString()) < 0;
    }
    else {
        return false;
    }
}


void MySortFilterProxyModel::beginResetModel()
{
    qDebug("%s",__PRETTY_FUNCTION__);
    QSortFilterProxyModel::beginResetModel();
}

void MySortFilterProxyModel::endResetModel()
{
    qDebug("%s",__PRETTY_FUNCTION__);
    QSortFilterProxyModel::endResetModel();
}
