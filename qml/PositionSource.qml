import QtQuick 2.0
import QtPositioning 5.3

PositionSource {
    id: gps
    active: true
    property var coordHistory: []
    property bool ready: false
    property var timeActivate:  Date.now()
    property var timePosition:  Date.now()

    onActiveChanged: {
        // Keep track of when positioning was (re)activated.
        if (gps.active) gps.timeActivate = Date.now();
    }

    onPositionChanged: {
        // Calculate direction as a median of individual direction values
        // calculated after significant changes in position. This should be
        // more stable than any direct value and usable with map.autoRotate.
        gps.ready = gps.position.latitudeValid &&
            gps.position.longitudeValid &&
            gps.position.coordinate.latitude &&
            gps.position.coordinate.longitude;
        gps.timePosition = Date.now();
        var threshold = gps.position.horizontalAccuracy || 15;
        if (threshold < 0 || threshold > 40) return;
        var coord = gps.position.coordinate;
        if (gps.coordHistory.length === 0)
            gps.coordHistory.push(QtPositioning.coordinate(
                coord.latitude, coord.longitude));
        var coordPrev = gps.coordHistory[gps.coordHistory.length-1];
        if (coordPrev.distanceTo(coord) > threshold) {
            gps.coordHistory.push(QtPositioning.coordinate(
                coord.latitude, coord.longitude));
            gps.coordHistory = gps.coordHistory.slice(-3); }

    }
}
