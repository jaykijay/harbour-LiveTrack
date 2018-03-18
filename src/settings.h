#ifndef SETTINGS_H
#define SETTINGS_H

#include <QSettings>
#include <QDebug>
//#include <QObject>

class Settings: public QSettings
        {
        Q_OBJECT
    public:
           explicit Settings();
            Q_INVOKABLE void initialize();
            Q_INVOKABLE void set(const QString& key, const QVariant &value);
            Q_INVOKABLE QVariant get(const QString& key);
            Q_INVOKABLE QString getString(const QString& key);
            Q_INVOKABLE bool getBool(const QString& key);
            Q_INVOKABLE int getInt(const QString& key);
};
#endif // SETTINGS_H
