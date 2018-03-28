# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = LiveTrack

CONFIG += sailfishapp

SOURCES += src/LiveTrack.cpp \
    src/settings.cpp

DISTFILES += qml/LiveTrack.qml \
    qml/cover/CoverPage.qml \
    qml/pages/SecondPage.qml \
    rpm/LiveTrack.changes.in \
    rpm/LiveTrack.changes.run.in \
    rpm/LiveTrack.spec \
    rpm/LiveTrack.yaml \
    translations/*.ts \
    LiveTrack.desktop \
    qml/PositionSource.qml \
    qml/Timer.qml

SAILFISHAPP_ICONS = 86x86 108x108 128x128
QT += qml quick positioning sensors


# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/LiveTrack-de.ts

HEADERS += \
    src/settings.h

RESOURCES +=
