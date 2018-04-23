import QtQuick 2.0
import "."
import QtPositioning 5.3

    Timer {
        property bool done: false
        property var coordPrev: null
        property var coord: null
        property int tempindextimer: 0
        property int threshold: 15
        property int intervald:livetracksettings.get("intervald");
        property int ignored: 0
        property bool debug: false //DEBUG

        id: positiontimer
        interval: intervald; running: false; repeat: false
        onTriggered:{
            done=true;
   if(gps.ready && gps.valid) {
            threshold = gps.position.horizontalAccuracy || 15;
        if (threshold > 0 && threshold < 60){ //stop if accuracy is too bad -> under 60meters

              coord = gps.position.coordinate;

              if (( (sendgood<2) || debug || coordPrev === null || (coordPrev.distanceTo(coord) > threshold)) ) { //coordPrev = NULL when the app is launching
               positiondata.positionvar.push({   positn: gps.position,
                                                  timestamp: (new Date).getTime(),
                                                  dirty: false });
                coordPrev = QtPositioning.coordinate(coord.latitude, coord.longitude);


                for(tempindextimer=0;positiondata.positionvar.length >0 && positiondata.positionvar.length > tempindextimer ;tempindextimer++){
                    if( positiondata.positionvar[tempindextimer].dirty === false || (positiondata.positionvar.timestamp > ((new Date).getTime() +180)) ){ //3minutes in sending
                        positiondata.positionvar[tempindextimer].dirty = true;
                        sendData(tempindextimer);}

                }}
              else ignored++;
                        }


            positiontimer.restart();
            done=false;
        }
    }
 }
