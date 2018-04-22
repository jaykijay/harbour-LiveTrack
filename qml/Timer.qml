import QtQuick 2.0
import "."

    Timer {
        property bool done: false
        property var coordPrev: null
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

              var coord = gps.position.coordinate;

              if ((coordPrev.distanceTo(coord) > threshold) || (sendgood<2) || debug || coordPrev === null  ) { //coordPrev = NULL when the app is launching
               console.log("Send Data \n");
               positiondata.positionvar.push({   positn: gps.position,
                                                  timestamp: (new Date).getTime(),
                                                  dirty: false });
               coordPrev = gps.position.coordinate;

                for(tempindextimer=0;positiondata.positionvar.length >0 && positiondata.positionvar.length > tempindextimer ;tempindextimer++){
                    if( positiondata.positionvar[tempindextimer].dirty === false ){
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
