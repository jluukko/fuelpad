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

#include "uiwrapper.h"
#include "userconfig.h"
#include "roleitemmodel.h"
#include "mysortfilterproxymodel.h"

// For debugging only
#include <iostream>

#define SEPARATOR " "

#define FIELD_DATE    0
#define FIELD_KM      1
#define FIELD_TRIP    2
#define FIELD_FILL    3
#define FIELD_CONSUM  4
#define FIELD_PRICE   5
#define FIELD_PPT     6
#define FIELD_PPL     7
#define FIELD_SERVICE 8
#define FIELD_OIL     9
#define FIELD_TIRES  10
#define FIELD_NOTES  11
#define FIELD_ID     12

struct FuelEntry {
    enum FuelEntryRoles {
        DateRole = Qt::UserRole + 1,
        KmRole,
        TripRole,
        FillRole,
        NotFullRole,
        ConsumRole,
        PriceRole,
        PptRole,
        PplRole,
        ServiceRole,
        OilRole,
        TiresRole,
        NotesRole,
        IdRole
    };
};

struct CarEntry {
    enum CarEntryRoles {
        MarkRole = Qt::UserRole + 1,
        ModelRole,
        YearRole,
        RegnumRole,
        NotesRole,
        FueltypeRole,
        TotalKmRole,
        LastMonthKmRole,
        LastYearKmRole,
        IdRole
    };
};

struct DriverEntry {
    enum DriverEntryRoles {
        FullnameRole = Qt::UserRole + 1,
        NicknameRole,
        IdRole
    };
};

UiWrapper::UiWrapper(Database *db)
{
    dataBase = db;
    unitSystem = new UnitSystem;

    UserConfig config;

    // Read data from config

//    unitSystem->setMainUnit(UnitSystem::SI);
//    unitSystem->setIndividualUnit(false);
    config.settings.beginGroup("Unit");
    unitSystem->setMainUnit((enum UnitSystem::unit)config.settings.value("UnitSystem", (int)UnitSystem::SI).toInt());
    unitSystem->setIndividualUnit(config.settings.value("IndividualUnit", false).toBool());
    unitSystem->setLengthUnit((enum UnitSystem::unit)config.settings.value("LengthUnit", (int)UnitSystem::SI).toInt());
    unitSystem->setVolumeUnit((enum UnitSystem::unit)config.settings.value("VolumeUnit", (int)UnitSystem::SI).toInt());
    unitSystem->setConsumeUnit((enum UnitSystem::unit)config.settings.value("ConsumeUnit", (int)UnitSystem::SI).toInt());
    unitSystem->setMassUnit((enum UnitSystem::unit)config.settings.value("MassUnit", (int)UnitSystem::SI).toInt());
    config.settings.endGroup();

    // For testing
//    unitSystem->setMainUnit(UnitSystem::US);
//    unitSystem->setLengthUnit(UnitSystem::US);
//    unitSystem->setVolumeUnit(UnitSystem::US);
//    unitSystem->setConsumeUnit(UnitSystem::US);
//    unitSystem->setMassUnit(UnitSystem::US);

    // Comment out since settings don't seem to work with simulator
//    db->setCurrentCar(config.settings.value("CurrentCar",1).toInt());
//    db->setCurrentDriver(config.settings.value("CurrentDriver",1).toInt());

    // Create models needed in Qml
    createFuelEntryModel();
    createCarDataModel();
    createDriverDataModel();
}

UiWrapper::~UiWrapper()
{
    delete unitSystem;
    delete sortModel;
}

static void setDataToFuelEntryModel(QStandardItem *it, Fuelrecord *data)
{
    it->setData(data->getDateUserUnit(), FuelEntry::DateRole);
    it->setData(data->getKmUserUnit(), FuelEntry::KmRole);
    it->setData(data->getTripUserUnit(), FuelEntry::TripRole);
    it->setData(data->getFillUserUnit(), FuelEntry::FillRole);
    it->setData(data->getNotFullFill(), FuelEntry::NotFullRole);
    it->setData(data->getConsumUserUnit(), FuelEntry::ConsumRole);
    it->setData(data->getPriceUserUnit(), FuelEntry::PriceRole);
    it->setData(data->getPptUserUnit(), FuelEntry::PptRole);
    it->setData(data->getPplUserUnit(), FuelEntry::PplRole);
    it->setData(data->getServiceUserUnit(), FuelEntry::ServiceRole);
    it->setData(data->getOilUserUnit(), FuelEntry::OilRole);
    it->setData(data->getTiresUserUnit(), FuelEntry::TiresRole);
    it->setData(data->getNotes(), FuelEntry::NotesRole);
    it->setData(data->getId(), FuelEntry::IdRole);
}

static void addRecordToFuelEntryModel(QStandardItemModel *model, Fuelrecord *data)
{
    QStandardItem* it = new QStandardItem();
    setDataToFuelEntryModel(it, data);
    model->appendRow(it);
//    model->insertRow(0, it);
}

static void setDataToCarEntryModel(QStandardItem *it, CarData *data,
                                   double totalKm, double lastMonthKm, double lastYearKm)
{
    int id = data->getId();
    it->setData(data->getMark(), CarEntry::MarkRole);
    it->setData(data->getModel(), CarEntry::ModelRole);
    it->setData(data->getYear(), CarEntry::YearRole);
    it->setData(data->getRegNum(), CarEntry::RegnumRole);
    it->setData(data->getNotes(), CarEntry::NotesRole);
    it->setData(data->getFuelType(), CarEntry::FueltypeRole);
    it->setData(id, CarEntry::IdRole);
    it->setData(QVariant(totalKm), CarEntry::TotalKmRole);
    it->setData(QVariant(lastMonthKm), CarEntry::LastMonthKmRole);
    it->setData(QVariant(lastYearKm), CarEntry::LastYearKmRole);
}

static void addRecordToCarEntryModel(QStandardItemModel *model, CarData *data,
                                     double totalKm, double lastMonthKm, double lastYearKm)
{
    QStandardItem* it = new QStandardItem();
    setDataToCarEntryModel(it, data, totalKm, lastMonthKm, lastYearKm);
    model->appendRow(it);
//    model->insertRow(0, it);
}

static void setDataToDriverEntryModel(QStandardItem *it, DriverData *data)
{
    int id = data->getId();
    it->setData(data->getFullName(), DriverEntry::FullnameRole);
    it->setData(data->getNickName(), DriverEntry::NicknameRole);
    it->setData(id, DriverEntry::IdRole);
}

static void addRecordToDriverEntryModel(QStandardItemModel *model, DriverData *data)
{
    QStandardItem* it = new QStandardItem();
    setDataToDriverEntryModel(it, data);
    model->appendRow(it);
//    model->insertRow(0, it);
}

void UiWrapper::updateAllModels(void)
{
//    sortModel->sort(FIELD_DATE, Qt::DescendingOrder);
    sortModel->invalidate();
}

void UiWrapper::reReadAllModels(void)
{
    // Fuel entry model
    fuelEntryModel->clear();
    addAllRecordsToFuelEntryModel(fuelEntryModel);

    // Car data model
    carDataModel->clear();
    addAllRecordsToCarEntryModel(carDataModel);

    // Driver data model
    driverDataModel->clear();
    addAllRecordsToDriverEntryModel(driverDataModel);
}

QStandardItem* UiWrapper::findFuelEntry(QString id)
{
    QStandardItem *it = 0;
    QList<QModelIndex> items = fuelEntryModel->match(fuelEntryModel->index(0,0), FuelEntry::IdRole, QVariant(id));
    if (items.size() == 1) {
        it = fuelEntryModel->itemFromIndex(items.at(0));
    }

    return it;
}

QStandardItem* UiWrapper::findCar(QString id)
{
    QStandardItem *it = 0;
    QList<QModelIndex> items = carDataModel->match(carDataModel->index(0,0), CarEntry::IdRole, QVariant(id));
    if (items.size() == 1) {
        it = carDataModel->itemFromIndex(items.at(0));
    }

    return it;
}

QStandardItem* UiWrapper::findDriver(QString id)
{
    QStandardItem *it = 0;
    QList<QModelIndex> items = driverDataModel->match(driverDataModel->index(0,0), DriverEntry::IdRole, QVariant(id));
    if (items.size() == 1) {
        it = driverDataModel->itemFromIndex(items.at(0));
    }

    return it;
}

void UiWrapper::addAllRecordsToFuelEntryModel(QStandardItemModel *model)
{
    Fuelrecord *data;

    if (dataBase->isOpen()) {

        if (dataBase->initRecordQuery()) {
            while  (dataBase->stepRecordQuery()) {
                data = dataBase->getValuesRecordQuery(*unitSystem);

                addRecordToFuelEntryModel(model, data);

                delete data;
            }
            qDebug("records added to model");
        }
        else {
            qDebug("initRecordQuery() not succesful");
        }
    }
}

void UiWrapper::addAllRecordsToCarEntryModel(QStandardItemModel *model)
{
    // @todo Note that an item called carData is already defined in this class
    vector<CarData> carData;
    int activeIndex;

    if (dataBase->isOpen()) {

        carData = dataBase->getCarData();

        for (vector<CarData>::size_type i=0; i < carData.size(); i++) {
            double totalKm, lastMonthKm, lastYearKm;
            totalKm = getTotalKm(carData[i].getId());
            lastMonthKm = getLastMonthKm(carData[i].getId());
            lastYearKm = getLastYearKm(carData[i].getId());
            addRecordToCarEntryModel(model, &carData[i], totalKm, lastMonthKm, lastYearKm);
            if (carData[i].getId() == dataBase->getCurrentCar().getId()) {
                activeIndex = i;
            }
        }

    }
}

void UiWrapper::addAllRecordsToDriverEntryModel(QStandardItemModel *model)
{
    vector<DriverData> drvData;
    int activeIndex;

    if (dataBase->isOpen()) {

        drvData = dataBase->getDriverData();

        for (vector<DriverData>::size_type i=0; i < drvData.size(); i++) {
            addRecordToDriverEntryModel(model, &drvData[i]);
            if (drvData[i].getId() == dataBase->getCurrentDriver().getId()) {
                activeIndex = i;
            }
        }

    }
}

void UiWrapper::createFuelEntryModel(void)
{
    Fuelrecord *data;
    QHash<int, QByteArray> roleNames;
    roleNames[FuelEntry::DateRole] =  "date";
    roleNames[FuelEntry::KmRole] =  "km";
    roleNames[FuelEntry::TripRole] =  "trip";
    roleNames[FuelEntry::FillRole] =  "fill";
    roleNames[FuelEntry::NotFullRole] =  "notfull";
    roleNames[FuelEntry::ConsumRole] =  "consum";
    roleNames[FuelEntry::PriceRole] =  "price";
    roleNames[FuelEntry::PptRole] =  "ppt";
    roleNames[FuelEntry::PplRole] =  "ppl";
    roleNames[FuelEntry::ServiceRole] =  "service";
    roleNames[FuelEntry::OilRole] =  "oil";
    roleNames[FuelEntry::TiresRole] =  "tires";
    roleNames[FuelEntry::NotesRole] =  "notes";
    roleNames[FuelEntry::IdRole] =  "databaseid";
    RoleItemModel *model = new RoleItemModel(roleNames);

    sortModel = new MySortFilterProxyModel(this, roleNames);

    addAllRecordsToFuelEntryModel(model);

    fuelEntryModel = model;

    sortModel->setSourceModel(fuelEntryModel);
    sortModel->sort(FIELD_DATE, Qt::DescendingOrder);
    sortModel->setDynamicSortFilter(true);
    sortModel->beginResetModel();
    sortModel->setSortRole(FuelEntry::DateRole);
    sortModel->endResetModel();
    sortModel->invalidate();

}

void UiWrapper::createCarDataModel(void)
{
    QHash<int, QByteArray> roleNames;
    roleNames[CarEntry::MarkRole] =  "mark";
    roleNames[CarEntry::ModelRole] =  "carmodel"; // "model" is not good for qml
    roleNames[CarEntry::YearRole] =  "year";
    roleNames[CarEntry::RegnumRole] =  "regnum";
    roleNames[CarEntry::NotesRole] =  "notes";
    roleNames[CarEntry::FueltypeRole] =  "fueltype";
    roleNames[CarEntry::IdRole] =  "databaseid";
    roleNames[CarEntry::TotalKmRole] =  "totalkm";
    roleNames[CarEntry::LastMonthKmRole] =  "lastmonthkm";
    roleNames[CarEntry::LastYearKmRole] =  "lastyearkm";
    RoleItemModel *model = new RoleItemModel(roleNames);

    addAllRecordsToCarEntryModel(model);

    carDataModel = model;

}

void UiWrapper::createDriverDataModel(void)
{
    QHash<int, QByteArray> roleNames;
    roleNames[DriverEntry::FullnameRole] =  "fullname";
    roleNames[DriverEntry::NicknameRole] =  "nickname";
    roleNames[DriverEntry::IdRole] =  "databaseid";
    RoleItemModel *model = new RoleItemModel(roleNames);

    addAllRecordsToDriverEntryModel(model);

    driverDataModel = model;

}


MySortFilterProxyModel *UiWrapper::getFuelEntryModel(void)
{
//    return mainViewModel;
    return sortModel;
}

RoleItemModel* UiWrapper::getCarEntryModel(void)
{
    return carDataModel;
}

RoleItemModel* UiWrapper::getDriverEntryModel(void)
{
    return driverDataModel;
}

void UiWrapper::addFuelEntry(int carid, QString date, double km, double trip, double fill, bool notFull,
                             double price, double service, double oil, double tires, QString notes)
{
    setCurrentCar(carid);

    Fuelrecord *record = new Fuelrecord(*unitSystem);
    qlonglong affectedId;
    QStandardItem *affectedItem;

    record->setAllValuesUserUnit(date,
                                 km,
                                 trip,
                                 fill,
                                 0.0 /* consumption is calculated in database add method */,
                                 price,
                                 0.0 /* price/litre is calculated in database add method */,
                                 0.0 /* price/trip is calculated in database add method */,
                                 service,
                                 oil,
                                 tires,
                                 notes,
                                 (qlonglong)0 /* id will be generated by the database add method */);

    std::cout << "Record before adding:" << "Date: " << record->getDate().toString().toStdString() << SEPARATOR
            << "Km: " << record->getKm().toString().toStdString() << SEPARATOR
              << "Trip: " << record->getTrip().toString().toStdString() << SEPARATOR
              << "Fill: " << record->getFill().toString().toStdString() << SEPARATOR
              << "Price: " << record->getPrice().toString().toStdString() << SEPARATOR
              << "Consumption: " << record->getConsum().toString().toStdString() << SEPARATOR
              << "Price/trip: " << record->getPpt().toString().toStdString() << SEPARATOR
              << "Notes: " << record->getNotes().toString().toStdString() << SEPARATOR
              << "Oil: " << record->getOil().toString().toStdString() << SEPARATOR
              << "Service: " << record->getService().toString().toStdString() << SEPARATOR
              << std::endl;

    // Add to database
    affectedId = dataBase->addNewRecord(*record, notFull);

    // Add to model
    addRecordToFuelEntryModel(fuelEntryModel, record);

    // Change also the affected id in model (in case of not full fill)
    if (affectedId != 0) {
        affectedItem = findFuelEntry(QVariant(affectedId).toString());
        if (affectedItem != 0) {
            qDebug("Found affected id from model and trying to update it");
            setDataToFuelEntryModel(affectedItem, dataBase->queryOneRecord(affectedId, *unitSystem));
        }
        else {
            qDebug("Did not find affected id from model");
        }
    }

    // Notify Qml side that list models have changed
    updateAllModels();

    delete record;

}

void UiWrapper::updateFuelEntry(int carid, QString id, QString date, double km, double trip, double fill, bool notFull,
                                double price, double service, double oil, double tires, QString notes)
{
    setCurrentCar(carid);

    Fuelrecord *record = new Fuelrecord(*unitSystem);
    QStandardItem *currentItem;
    qlonglong affectedId;
    QStandardItem *affectedItem;

    record->setAllValuesUserUnit(date,
                                 km,
                                 trip,
                                 fill,
                                 0.0 /* consumption is calculated in database add method */,
                                 price,
                                 0.0 /* price/litre is calculated in database add method */,
                                 0.0 /* price/trip is calculated in database add method */,
                                 service,
                                 oil,
                                 tires,
                                 notes,
                                 id.toLongLong());

    std::cout << "Record before editing:" << "Id: " << record->getId().toString().toStdString() << SEPARATOR
              << "Date: " << record->getDate().toString().toStdString() << SEPARATOR
              << "Km: " << record->getKm().toString().toStdString() << SEPARATOR
              << "Trip: " << record->getTrip().toString().toStdString() << SEPARATOR
              << "Fill: " << record->getFill().toString().toStdString() << SEPARATOR
              << "Price: " << record->getPrice().toString().toStdString() << SEPARATOR
              << "Consumption: " << record->getConsum().toString().toStdString() << SEPARATOR
              << "Price/trip: " << record->getPpt().toString().toStdString() << SEPARATOR
              << "Notes: " << record->getNotes().toString().toStdString() << SEPARATOR
              << "Oil: " << record->getOil().toString().toStdString() << SEPARATOR
              << "Service: " << record->getService().toString().toStdString() << SEPARATOR
              << std::endl;

    // Commented out at this point of testing
    affectedId = dataBase->updateRecord(*record, notFull);

    // Change the data in the model
    currentItem = findFuelEntry(id);
    if (currentItem != 0) {
        qDebug("Found current id from model and trying to update it");
        setDataToFuelEntryModel(currentItem, dataBase->queryOneRecord(id.toLong(), *unitSystem));
    }
    else {
        qDebug("Did not find current id from model");
    }

    // Change also the affected id in model (in case of not full fill)
    if (affectedId != 0) {
        affectedItem = findFuelEntry(QVariant(affectedId).toString());
        if (affectedItem != 0) {
            qDebug("Found affected id from model and trying to update it");
            setDataToFuelEntryModel(affectedItem, dataBase->queryOneRecord(affectedId, *unitSystem));
        }
        else {
            qDebug("Did not find affected id from model");
        }
    }

    // @todo Notify Qml side somehow that the model has changed
//    sortModel->sort(FIELD_DATE, Qt::DescendingOrder);
//    fuelEntryModel->sort(FIELD_DATE, Qt::DescendingOrder);
//    sortModel->invalidate();
    updateAllModels();

}

void UiWrapper::deleteRecord(QString id)
{
    QStandardItem *currentItem;

    qDebug("%s",__PRETTY_FUNCTION__);

    dataBase->deleteRecord(id.toLongLong());
    currentItem = findFuelEntry(id);
    if (currentItem != 0) {
        fuelEntryModel->removeRows(currentItem->row(), 1);
    }
    else {
        qDebug("Did not found current record - can't delete it!");
    }

    // Notify Qml side that list models have changed
    updateAllModels();
}

QString UiWrapper::getCarMark(int carid=-1)
{
    CarData oldCarData;
    QString mark;

    if (carid != -1) {
        oldCarData = dataBase->getCurrentCar();
        dataBase->setCurrentCar(carid);
    }

    mark = dataBase->getCurrentCar().getMark();

    if (carid != -1) {
        dataBase->setCurrentCar(oldCarData.getId());
    }

    return mark;
}

QString UiWrapper::getCarModel(int carid=-1)
{
    CarData oldCarData;
    QString model;

    if (carid != -1) {
        oldCarData = dataBase->getCurrentCar();
        dataBase->setCurrentCar(carid);
    }

    model = dataBase->getCurrentCar().getModel() ;

    if (carid != -1) {
        dataBase->setCurrentCar(oldCarData.getId());
    }

    return model;
}

double UiWrapper::getTotalKm(int carid=-1)
{
    CarData oldCarData;

    if (carid != -1) {
        oldCarData = dataBase->getCurrentCar();
        dataBase->setCurrentCar(carid);
    }

    Database::dbtimespan totalKm = dataBase->getTotalKm(*unitSystem);

    if (carid != -1) {
        dataBase->setCurrentCar(oldCarData.getId());
    }

    return totalKm.overall;
}

double UiWrapper::getLastMonthKm(int carid=-1)
{
    CarData oldCarData;

    if (carid != -1) {
        oldCarData = dataBase->getCurrentCar();
        dataBase->setCurrentCar(carid);
    }

    Database::dbtimespan totalKm = dataBase->getTotalKm(*unitSystem);

    if (carid != -1) {
        dataBase->setCurrentCar(oldCarData.getId());
    }

    return totalKm.lastmonth;
}

double UiWrapper::getLastYearKm(int carid=-1)
{
    CarData oldCarData;

    if (carid != -1) {
        oldCarData = dataBase->getCurrentCar();
        dataBase->setCurrentCar(carid);
    }

    Database::dbtimespan totalKm = dataBase->getTotalKm(*unitSystem);

    if (carid != -1) {
        dataBase->setCurrentCar(oldCarData.getId());
    }

    return totalKm.lastyear;
}

void UiWrapper::addDriver(QString fullname, QString nickname)
{
    qDebug("%s called!\n",__PRETTY_FUNCTION__);
    DriverData *record = new DriverData();

    record->setFullName(fullname);
    record->setNickName(nickname);

    dataBase->addDriver(fullname.toStdString(), nickname.toStdString());

    addRecordToDriverEntryModel(driverDataModel, record);

    // Notify Qml side that list models have changed
    updateAllModels();
}

void UiWrapper::updateDriver(QString id, QString fullname, QString nickname)
{
    qDebug("%s called!\n",__PRETTY_FUNCTION__);
    qlonglong Id = id.toLongLong();
    DriverData *record = new DriverData();
    QStandardItem *currentItem;

    qDebug("id = %s, id = %ld\n",id.toStdString().c_str(),Id);

    record->setFullName(fullname);
    record->setNickName(nickname);
    record->setId(Id);

    dataBase->updateDriver(Id, fullname.toStdString(), nickname.toStdString());

    // Change the data in the model
    currentItem = findDriver(id);
    if (currentItem != 0) {
        qDebug("Found current id from model and trying to update it");
        setDataToDriverEntryModel(currentItem, record);
    }
    else {
        qDebug("Did not find current id from model");
    }

    // Notify Qml side that list models have changed
    updateAllModels();
}

void UiWrapper::deleteDriver(QString id)
{
    qDebug("%s called!\n",__PRETTY_FUNCTION__);
    QStandardItem *currentItem;

    dataBase->deleteDriver(id.toLongLong());

    currentItem = findDriver(id);
    if (currentItem != 0) {
        qDebug("Found current id from model and trying to update it");
        driverDataModel->removeRows(currentItem->row(), 1);
    }
    else {
        qDebug("Did not find current id from model");
    }

    // Notify Qml side that list models have changed
    updateAllModels();
}

void UiWrapper::addCar(QString mark, QString model, QString year, QString regist, QString notes, quint8 fueltype)
{
    qDebug("%s called!\n",__PRETTY_FUNCTION__);
    CarData *record = new CarData();

    record->setMark(mark);
    record->setModel(model);
    record->setYear(year.toUInt());
    record->setRegNum(regist);
    record->setNotes(notes);
    record->setFuelType((enum CarData::FuelType)fueltype);

    dataBase->addCar(mark.toStdString(), model.toStdString(), year.toStdString(), regist.toStdString(), notes.toStdString(), fueltype);

    addRecordToCarEntryModel(carDataModel, record, 0.0, 0.0, 0.0);

    // Notify Qml side that list models have changed
    updateAllModels();

    delete record;
}

void UiWrapper::updateCar(QString id, QString mark, QString model, QString year, QString regist, QString notes, quint8 fueltype)
{
    qDebug("%s called!\n",__PRETTY_FUNCTION__);
    qlonglong Id = id.toLongLong();
    CarData *record = new CarData();
    QStandardItem *currentItem;

    record->setMark(mark);
    record->setModel(model);
    record->setYear(year.toUInt());
    record->setRegNum(regist);
    record->setNotes(notes);
    record->setFuelType((enum CarData::FuelType)fueltype);
    record->setId(Id);

    dataBase->updateCar(id.toLongLong(), mark.toStdString(), model.toStdString(),
                        year.toStdString(), regist.toStdString(), notes.toStdString(), fueltype);

    // Change the data in the model
    currentItem = findCar(id);
    if (currentItem != 0) {
        qDebug("Found current id from model and trying to update it");
        setDataToCarEntryModel(currentItem, record, getTotalKm(Id), getLastMonthKm(Id), getLastYearKm(Id));
    }
    else {
        qDebug("Did not find current id from model");
    }

    // Notify Qml side that list models have changed
    updateAllModels();

    delete record;
}

void UiWrapper::deleteCar(QString id)
{
    qDebug("%s called!\n",__PRETTY_FUNCTION__);
    QStandardItem *currentItem;

    dataBase->deleteCar(id.toLongLong());

    currentItem = findCar(id);
    if (currentItem != 0) {
        qDebug("Found current id from model and trying to update it");
        carDataModel->removeRows(currentItem->row(), 1);
    }
    else {
        qDebug("Did not find current id from model");
    }

    // Notify Qml side that list models have changed
    updateAllModels();
}

void UiWrapper::setSortColumn(int col, Qt::SortOrder order = Qt::DescendingOrder)
{
    sortModel->beginResetModel();
    sortModel->sort(col, order);
    sortModel->endResetModel();
}

void UiWrapper::setCurrentCar(int carid)
{
    if (carid != -1) {
        dataBase->setCurrentCar(carid);

        reReadAllModels();
        updateAllModels();
    }
}

void UiWrapper::setMainUnit(int unit, bool individualUnit)
{
    if (unit >= UnitSystem::SI || unit < UnitSystem::NUMUNITS) {
        unitSystem->setMainUnit((UnitSystem::unit)unit);

        unitSystem->setIndividualUnit(individualUnit);

        reReadAllModels();
        updateAllModels();
    }
}

void UiWrapper::setLengthUnit(int unit)
{
    if ((UnitSystem::unit)unit != unitSystem->getLengthUnit() && (unit >= UnitSystem::SI || unit < UnitSystem::NUMUNITS)) {
        unitSystem->setLengthUnit((UnitSystem::unit)unit);

        reReadAllModels();
        updateAllModels();
    }
}

void UiWrapper::setMassUnit(int unit)
{
    if ((UnitSystem::unit)unit != unitSystem->getMassUnit() && (unit >= UnitSystem::SI || unit < UnitSystem::NUMUNITS)) {
        unitSystem->setMassUnit((UnitSystem::unit)unit);

        reReadAllModels();
        updateAllModels();
    }

}

void UiWrapper::setVolumeUnit(int unit)
{
    if ((UnitSystem::unit)unit != unitSystem->getVolumeUnit() && (unit >= UnitSystem::SI || unit < UnitSystem::NUMUNITS)) {
        unitSystem->setVolumeUnit((UnitSystem::unit)unit);

        reReadAllModels();
        updateAllModels();
    }
}

void UiWrapper::setConsumeUnit(int unit)
{
    if ((UnitSystem::unit)unit != unitSystem->getConsumeUnit() && (unit >= UnitSystem::SI || unit < UnitSystem::NUMUNITS)) {
        unitSystem->setConsumeUnit((UnitSystem::unit)unit);

        reReadAllModels();
        updateAllModels();
    }
}


//-------------------------------------------------------------------
//
// Units
//
//-------------------------------------------------------------------
int UiWrapper::getLengthUnit(void)
{
    return unitSystem->getLengthUnit();
}

int UiWrapper::getMassUnit(void)
{
    return unitSystem->getMassUnit();
}

int UiWrapper::getVolumeUnit(void)
{
    return unitSystem->getVolumeUnit();
}

int UiWrapper::getConsumeUnit(void)
{
    return unitSystem->getConsumeUnit();
}

QString UiWrapper::getCurrencySymbol(void)
{
    return unitSystem->getCurrencySymbol();
}


#if 0
void UiWrapper::on_action_Add_record_triggered()
{
    qlonglong affectedId;
    AddRecordDialog dialog(this, dataBase, unitSystem);

    qDebug("File|Add record selected\n");

    if (dialog.exec() == QDialog::Accepted) {
        Fuelrecord *record = new Fuelrecord(*unitSystem);
        qlonglong carId = dialog.getField("carid").toLongLong();
        qlonglong driverId = dialog.getField("driverid").toLongLong();

        if (carId != dataBase->getCurrentCar().getId()) {
            qDebug("Changing carid to %ld",carId);
            dataBase->setCurrentCar(carId);
        }

        if (driverId != dataBase->getCurrentDriver().getId()) {
            qDebug("Changing driverid to %ld",driverId);
            dataBase->setCurrentDriver(driverId);
        }

        record->setAllValuesUserUnit(dialog.getField("date").toString(),
                                     dialog.getField("km").toDouble(),
                                     dialog.getField("trip").toDouble(),
                                     dialog.getField("fill").toDouble(),
                                     0.0 /* consumption is calculated in database add method */,
                                     dialog.getField("price").toDouble(),
                                     0.0 /* price/litre is calculated in database add method */,
                                     0.0 /* price/trip is calculated in database add method */,
                                     dialog.getField("service").toDouble(),
                                     dialog.getField("oil").toDouble(),
                                     dialog.getField("tires").toDouble(),
                                     dialog.getField("notes").toString(),
                                     (qlonglong)0 /* id will be generated by the database add method */);

        affectedId = dataBase->addNewRecord(*record, dialog.getField("notfull").toBool());

        // @todo Use also affectedId to update a affected record
//        addRecordToModel(ui->mainTreeView->model(), record);

        delete record;

    }
    else {
        qDebug("Canceled\n");
    }
}

void UiWrapper::on_action_Edit_record_triggered()
{
    qlonglong affectedId;
    const QModelIndex selectedIndex = ui->mainTreeView->selectionModel()->currentIndex();
    int row = selectedIndex.row();
    qlonglong selectedId = selectedIndex.sibling(row,FIELD_ID).data().toLongLong();
//    QString selectedText = selectedIndex.data(Qt::DisplayRole).toString();

    AddRecordDialog dialog(this, dataBase, unitSystem);

    dialog.setWindowTitle(QObject::tr("Edit record"));

    // @todo Get driver and car from record, now current car and driver are used
    dialog.setCar(dataBase->getCurrentCar().getId());
    dialog.setDriver(dataBase->getCurrentDriver().getId());
    // @todo Remember user unit
    dialog.setField("date", selectedIndex.sibling(row, FIELD_DATE).data());
    dialog.setField("km",   selectedIndex.sibling(row, FIELD_KM).data());
    dialog.setField("trip", selectedIndex.sibling(row, FIELD_TRIP).data());
    dialog.setField("fill", selectedIndex.sibling(row, FIELD_FILL).data());
    dialog.setField("notfull", (selectedIndex.sibling(row, FIELD_FILL).data().toFloat() > 0.0) &
                    (selectedIndex.sibling(row, FIELD_CONSUM).data().toFloat() < 1.0e-4) );
    dialog.setField("price", selectedIndex.sibling(row, FIELD_PRICE).data());
    dialog.setField("notes", selectedIndex.sibling(row, FIELD_NOTES).data());
    dialog.setField("oil", selectedIndex.sibling(row, FIELD_OIL).data());
    dialog.setField("service", selectedIndex.sibling(row, FIELD_SERVICE).data());

    if (dialog.exec() == QDialog::Accepted) {
        qDebug("Accepted");
        Fuelrecord *record = new Fuelrecord(*unitSystem);
        qlonglong carId = dialog.getField("carid").toLongLong();
        qlonglong driverId = dialog.getField("driverid").toLongLong();

        if (carId != dataBase->getCurrentCar().getId()) {
            qDebug("Changing carid to %ld",carId);
            dataBase->setCurrentCar(carId);
        }

        if (driverId != dataBase->getCurrentDriver().getId()) {
            qDebug("Changing driverid to %ld",driverId);
            dataBase->setCurrentDriver(driverId);
        }

        std::cout << "Carid: " << dialog.getField("carid").toString().toStdString() << SEPARATOR
                  << "Date: " << dialog.getField("date").toString().toStdString() << SEPARATOR
                  << "Km: " << dialog.getField("km").toString().toStdString() << SEPARATOR
                  << "Trip: " << dialog.getField("trip").toString().toStdString() << SEPARATOR
                  << "Fill: " << dialog.getField("fill").toString().toStdString() << SEPARATOR
                  << (dialog.getField("notfull").toBool() ? "Not full" : "Full") << SEPARATOR << "Tank" << SEPARATOR
                  << "Price: " << dialog.getField("price").toString().toStdString() << SEPARATOR
                  << "Notes: " << dialog.getField("notes").toString().toStdString() << SEPARATOR
                  << "Oil: " << dialog.getField("oil").toString().toStdString() << SEPARATOR
                  << "Service: " << dialog.getField("service").toString().toStdString() << SEPARATOR
                  << std::endl;

        record->setAllValuesUserUnit(dialog.getField("date").toString(),
                                     dialog.getField("km").toDouble(),
                                     dialog.getField("trip").toDouble(),
                                     dialog.getField("fill").toDouble(),
                                     0.0 /* consumption is calculated in database add method */,
                                     dialog.getField("price").toDouble(),
                                     0.0 /* price/litre is calculated in database add method */,
                                     0.0 /* price/trip is calculated in database add method */,
                                     dialog.getField("service").toDouble(),
                                     dialog.getField("oil").toDouble(),
                                     dialog.getField("tires").toDouble(),
                                     dialog.getField("notes").toString(),
                                     selectedId);

        std::cout << "Record before edit:" << "Date: " << record->getDate().toString().toStdString() << SEPARATOR
                << "Km: " << record->getKm().toString().toStdString() << SEPARATOR
                  << "Trip: " << record->getTrip().toString().toStdString() << SEPARATOR
                  << "Fill: " << record->getFill().toString().toStdString() << SEPARATOR
                  << "Price: " << record->getPrice().toString().toStdString() << SEPARATOR
                  << "Consumption: " << record->getConsum().toString().toStdString() << SEPARATOR
                  << "Price/trip: " << record->getPpt().toString().toStdString() << SEPARATOR
                  << "Notes: " << record->getNotes().toString().toStdString() << SEPARATOR
                  << "Oil: " << record->getOil().toString().toStdString() << SEPARATOR
                  << "Service: " << record->getService().toString().toStdString() << SEPARATOR
                  << std::endl;

        affectedId = dataBase->updateRecord(*record, dialog.getField("notfull").toBool());

        // @todo Update also affectedId
        setDataToModel(ui->mainTreeView->model(), record, row);

        std::cout << "Record after edit:" << "Date: " << record->getDate().toString().toStdString() << SEPARATOR
                << "Km: " << record->getKm().toString().toStdString() << SEPARATOR
                  << "Trip: " << record->getTrip().toString().toStdString() << SEPARATOR
                  << "Fill: " << record->getFill().toString().toStdString() << SEPARATOR
                  << "Price: " << record->getPrice().toString().toStdString() << SEPARATOR
                  << "Consumption: " << record->getConsum().toString().toStdString() << SEPARATOR
                  << "Price/trip: " << record->getPpt().toString().toStdString() << SEPARATOR
                  << "Notes: " << record->getNotes().toString().toStdString() << SEPARATOR
                  << "Oil: " << record->getOil().toString().toStdString() << SEPARATOR
                  << "Service: " << record->getService().toString().toStdString() << SEPARATOR
                  << "Id: " << record->getId().toString().toStdString() << SEPARATOR
                  << std::endl;

        delete record;
    }
    else {
        qDebug("Canceled\n");
    }

    qDebug("File|Edit record selected\n");
    std::cout << "Selected row = " << row << " database id = " << selectedIndex.sibling(row,FIELD_ID).data().toString().toStdString() << std::endl;
}

void UiWrapper::on_action_Delete_record_triggered()
{
    qlonglong affectedId;
    const QModelIndex selectedIndex = ui->mainTreeView->selectionModel()->currentIndex();
    int row = selectedIndex.row();
    qlonglong selectedId = selectedIndex.sibling(row,FIELD_ID).data().toLongLong();

    qDebug("File|Delete record selected\n");

    std::cout << "Selected row = " << row << " database id = " << selectedId << std::endl;

    DeleteConfirmDialog dialog(this);

    if (dialog.exec() == QDialog::Accepted) {
        qDebug("Accepted");

        // @todo Actual removal of a record
        dataBase->deleteRecord(selectedId);
        ui->mainTreeView->model()->removeRow(row, selectedIndex.parent());
    }
    else {
        qDebug("Canceled\n");
    }
}

void UiWrapper::on_actionStatistics_triggered()
{
    qDebug("Report|Statistics selected\n");
}

void UiWrapper::on_actionReport_triggered()
{
    qDebug("Report|Report selected\n");
}

void UiWrapper::on_action_Settings_triggered()
{
    SettingsDialog dialog(this, dataBase);

    qDebug("File|Settings selected\n");

    if (dialog.exec() == QDialog::Accepted) {
        qDebug("Accepted");

        // @todo Do something with the new settings
    }
    else {
        qDebug("Canceled\n");
    }

}

void UiWrapper::on_action_Sort_by_triggered()
{
    qDebug("View|Sort by selected\n");
}

void UiWrapper::on_actionSort_ascending_triggered()
{
    qDebug("View|Sort order|Ascending selected\n");
}

void UiWrapper::on_actionSort_descending_triggered()
{
    qDebug("View|Sort order|Descending selected\n");
}

void UiWrapper::on_action_Reminders_triggered()
{
    qDebug("Tools|Reminders selected\n");
}

void UiWrapper::on_action_Driving_log_triggered()
{
    qDebug("Tools|Driving log selected\n");
}
#endif
