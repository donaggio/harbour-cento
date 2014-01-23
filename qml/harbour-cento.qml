/*
  Copyright (C) 2014 Luca Donaggio
  Contact: Luca Donaggio <donaggio@gmail.com>
  All rights reserved.

  You may use this file under the terms of MIT license
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "pages"

ApplicationWindow
{
    id: main
    property int currentNumber: 0
    property bool noMoreMoves: false
    property var db: ({})

    initialPage: game
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    GamePage {
        id: game
    }

    Component.onCompleted: {
        try {
            db = LocalStorage.openDatabaseSync("CentoDB", "1.0", "Cento High Scores", 1000000);
            db.transaction(
               function(tx) {
                   // Create high scores table if it doesn't already exist
                   tx.executeSql('CREATE TABLE IF NOT EXISTS hiscore(date DATE, score INT)');
               }
            );
        } catch (error) {
            console.log(error);
        }
    }
}


