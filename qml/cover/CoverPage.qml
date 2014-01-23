/*
  Copyright (C) 2014 Luca Donaggio
  Contact: Luca Donaggio <donaggio@gmail.com>
  All rights reserved.

  You may use this file under the terms of MIT license
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Label {
        id: label
        width: (parent.width - (2 * Theme.paddingSmall))
        anchors.centerIn: parent
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        text: 'Cento<br /><br />' + ((main.currentNumber > 0) ? 'Your ' + (!main.noMoreMoves ? 'present ' : '') + 'score is: ' + main.currentNumber + (main.noMoreMoves ? '<br /><br />Game over!' : '') : 'New game')
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: game.resetBoard();
        }
    }
}
