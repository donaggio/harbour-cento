/*
  Copyright (C) 2014, 2015 Luca Donaggio
  Contact: Luca Donaggio <donaggio@gmail.com>
  All rights reserved.

  You may use this file under the terms of MIT license
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    /*
     * Cover background
     */
    Image {
        x: -Theme.paddingLarge
        y: x
        source: "../../icons/cover-background.png"
    }

    Column {
        width: (parent.width - (2 * Theme.paddingSmall))
        anchors.centerIn: parent
        spacing: Theme.paddingMedium

        Label {
            id: labelNewGame
            visible: (main.currentNumber == 0)
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("New game")
        }

        Label {
            visible: !labelNewGame.visible
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: qsTr("Your %1score is: %2").arg((!main.noMoreMoves ? qsTr("present ") : "")).arg(main.currentNumber)
        }

        Label {
            visible: (!labelNewGame.visible && main.noMoreMoves)
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Game over!")
        }
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: game.resetBoard();
        }
    }
}
