#include "settings.h"

Settings::Settings() : QSettings(){
    }

void Settings::initialize()
{
    qDebug("Initializing settings");
    if (!this->contains("URL"))
        this->setValue("URL", "https://my.url.local/trackme/");
    if (!this->contains("ID"))
        this->setValue("ID", "jolla");
    if (!this->contains("intervald"))
        this->setValue("intervald", 1000);

}
void Settings::set(const QString& key, const QVariant &value){
    this->setValue(key, value);
}
QVariant Settings::get(const QString& key){
   QVariant value = this->value(key);
    return value;

}
QString Settings::getString(const QString& key){
   QVariant value = get(key);
   Q_ASSERT(value.canConvert(QVariant::String));
   return value.toString();

}
bool Settings::getBool(const QString& key){
    QVariant value = get(key);
    Q_ASSERT(value.canConvert(QVariant::Bool));
    return value.toBool();

}
int Settings::getInt(const QString& key){
    QVariant value = get(key);
    Q_ASSERT(value.canConvert(QVariant::Int));
    return value.toInt();
}
