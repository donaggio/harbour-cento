# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-cento

CONFIG += sailfishapp

DEFINES += VERSION=$$VERSION

SOURCES += src/harbour-cento.cpp

OTHER_FILES += qml/harbour-cento.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-cento.spec \
    rpm/harbour-cento.yaml \
    harbour-cento.desktop \
    qml/pages/GamePage.qml \
    qml/pages/AboutPage.qml \
    harbour-cento.png \
    qml/dialogs/GameOverDialog.qml \
    qml/pages/HiScoresPage.qml \
    qml/lib/dbmanager.js
