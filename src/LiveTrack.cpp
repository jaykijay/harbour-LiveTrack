#ifdef QT_QML_DEBUG
#include <QtDebug>
#endif

#include <sailfishapp.h>
#include "settings.h"
#include <QtQuick>


int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    QQmlContext *context = view.data()->rootContext();
    Settings livetracksettings;
    livetracksettings.initialize();
    context->setContextProperty("livetracksettings", &livetracksettings);

    view->setSource(SailfishApp::pathTo("qml/LiveTrack.qml"));
    view->show();
    return app->exec();
}


