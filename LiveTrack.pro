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

SOURCES += src/harbour-livetrack.cpp \
    src/settings.cpp

DISTFILES += qml/LiveTrack.qml \
    qml/cover/CoverPage.qml \
    qml/pages/SecondPage.qml \
    rpm/LiveTrack.changes.in \
    rpm/LiveTrack.changes.run.in \
    rpm/LiveTrack.spec \
    rpm/LiveTrack.yaml \
    translations/*.ts \
    harbour-livetrack.desktop \
    qml/PositionSource.qml \
    qml/Timer.qml \
    qml/DetailItem2.qml \
    qml/About.qml \
    icons/harbour-livetrack.svg \
    icons/harbour-livetrack.svg \
    icons/108x108/harbour-livetrack-108.png \
    icons/128x128/harbour-livetrack-128.png \
    icons/172x172/harbour-livetrack-172.png \
    icons/86x86/livetrack-86.png \
    icons/livetrack.svg \
    icons/108x108/harbour-livetrack.png \
    icons/128x128/harbour-livetrack.png \
    icons/172x172/harbour-livetrack.png \
    icons/86x86/harbour-livetrack.png \
    icons/harbour-livetrack.svg \
    icons/108x108/harbour-livetrack.png \
    icons/128x128/harbour-livetrack.png \
    icons/172x172/harbour-livetrack.png \
    icons/86x86/harbour-livetrack.png \
    icons/harbour-livetrack.svg \
    qml/FirstPage.qml

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172
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
