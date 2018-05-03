import QtQuick 2.0
import "."
import QtPositioning 5.3

    Timer {
        property int tosend: 0
        property var coordPrev: null
        property var coord: null
        property var tempspeed: null
        property int tempaccuracy: 0
        property int tempaltitude: 0
        property int tempindextimer: 0
        property int threshold: 15
        property int intervald:livetracksettings.get("intervald");
        property int ignored: 0
        property bool debug: false //DEBUG

        id: positiontimer
        interval: intervald; running: false; repeat: false
        onTriggered:{
            tosend = positiondata.positionvar.length;
       //     console.log("Length:"+tosend+"\n");
   if(gps.ready && gps.valid) {
            threshold = gps.position.horizontalAccuracy || 15;
        if (threshold > 0 && threshold < 60){ //stop if accuracy is too bad -> under 60meters

              coord = gps.position.coordinate;
              tempspeed = gps.position.speed;
              tempaccuracy= gps.position.horizontalAccuracy;
              tempaltitude= gps.position.coordinate.altitude;

              if (( (sendgood<2) || debug || coordPrev === null || (coordPrev.distanceTo(coord) > threshold)) ) { //coordPrev = NULL when the app is launching
               positiondata.positionvar.push({   positn: QtPositioning.coordinate(coord.latitude, coord.longitude), //can't do direct, it will just link it -.-
                                                 speed: tempspeed,
                                                 timestamp: (new Date).getTime(),
                                                 horizontalAccuracy: tempaccuracy,
                                                 alt: tempaltitude,
                                                 dirty: 0 });
                 // console.log(" variable:"+tempspeed +"\n");
                //  console.log(positiondata.positionvar[positiondata.positionvar.length -1].speed +" speed: "+ positiondata.positionvar[positiondata.positionvar.length -1].horizontalAccuracy +"\n");
                coordPrev = QtPositioning.coordinate(coord.latitude, coord.longitude);

                //console.log(positiondata.positionvar[0].positn.longitude +"time "+  positiondata.positionvar[0].timestamp );

                for(tempindextimer=0;positiondata.positionvar.length >0 && positiondata.positionvar.length > tempindextimer ;tempindextimer++){
                    if( positiondata.positionvar[tempindextimer].dirty === 0){
                        positiondata.positionvar[tempindextimer].dirty = 1;
                        sendData(tempindextimer);}
                    else if(((positiondata.positionvar[tempindextimer].timestamp +324000) < (new Date).getTime()) && ((positiondata.positionvar[tempindextimer].dirty +324000) < (new Date).getTime()) ){ //xminutes in sending(after 2nd time dirty counts the minutes to resend)
                        positiondata.positionvar[tempindextimer].dirty = (new Date).getTime();
                        sendData(tempindextimer);}
                    }
                    }
              else ignored++;
              }}

            positiontimer.restart();
        }
    }
