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
TARGET = harbour-cento

CONFIG += sailfishapp

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
    qml/lib/dbmanager.js \
    icon128/harbour-cento.png \
    icons/cover-background.png

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-cento-it.ts

# Custom icons and images
images.files = icons
images.path = /usr/share/$${TARGET}
INSTALLS += images

# App version
DEFINES += APP_VERSION=\"\\\"$${VERSION}\\\"\"

# 128x128 Launcher icon
icon128.files = icon128/harbour-cento.png
icon128.path = /usr/share/icons/hicolor/128x128/apps

INSTALLS += icon128
