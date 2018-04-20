import QtQuick 2.0
import QtPositioning 5.3

PositionSource {
    id: gps
    active: true
    property bool ready: false
    property var timeActivate:  Date.now()

    onActiveChanged: {
        if (gps.active) gps.timeActivate = Date.now();
    }

    onPositionChanged: {
        gps.ready = gps.position.latitudeValid &&
            gps.position.longitudeValid &&
            gps.position.coordinate.latitude &&
            gps.position.coordinate.longitude;
        }
}
