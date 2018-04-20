import QtQuick 2.0
import "."

    Timer {
        property bool done: false
        property var coordPrev: null
        property int tempindextimer: 0
        property int threshold: 15
        property int intervald:livetracksettings.get("intervald");

        id: positiontimer
        interval: intervald; running: false; repeat: false
        onTriggered:{
            done=true;
   if(gps.ready && gps.valid) {
            threshold = gps.position.horizontalAccuracy || 15;
        if (threshold > 0 && threshold < 60){ //stop if accuracy is too bad -> under 60meters

              var coord = gps.position.coordinate;
              if(coordPrev == null ){
                  positiondata.positionvar.push({   positn: gps.position,
                                                    timestamp: (new Date).getTime(),
                                                    dirty: false });
                  coordPrev = positiondata.positionvar[positiondata.positionvar.length -1].positn.coordinate;
                  }
                  else{
                  coordPrev = positiondata.positionvar[positiondata.positionvar.length -1].positn.coordinate;
               }

              if ((coordPrev.distanceTo(coord) > threshold) || (sendgood<3000)) { //Debug

                positiondata.positionvar.push({   positn: gps.position,
                                                  timestamp: (new Date).getTime(),
                                                  dirty: false });

                for(tempindextimer=0;positiondata.positionvar.length >1 &&positiondata.positionvar.length > (tempindextimer +1) ;tempindextimer++){
                    if( positiondata.positionvar[tempindextimer].dirty === false ){
                        positiondata.positionvar[tempindextimer].dirty = true;
                        sendData(tempindextimer);}

                    }}}
            positiontimer.restart();
            done=false;
        }
    }
 }
