/*
  Copyright (C) 2014, 2015 Luca Donaggio
  Contact: Luca Donaggio <donaggio@gmail.com>
  All rights reserved.

  You may use this file under the terms of MIT license
*/

import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    property alias score: scoreLabel.text

    function getTextByScore(score) {
        var text = "";

        if (score == 100) {
            text = qsTr("Here comes the winner!");
        } else if (score >= 95 && score <= 99 ) {
            text = qsTr("A really great score, you're almost there!");
        } else if (score >= 90 && score < 95) {
            text = qsTr("Very nice! Just a little more effort ...");
        } else if (score >= 80 && score < 90) {
            text = qsTr("Good! Let's try again, won't you?");
        } else if (score >= 70 && score < 80) {
            text = qsTr("Oh, come on! I know you can do better!");
        } else {
            text = qsTr("Mmmm ... What can I say? Bah!");
        }

        return text;
    }

    DialogHeader {
        id: header

        width: parent.width
        acceptText: qsTr("Start new game")
    }

    Column {
        anchors { top: header.bottom; left: parent.left; leftMargin: Theme.horizontalPageMargin; right: parent.right; rightMargin: Theme.horizontalPageMargin }
        spacing: Theme.paddingLarge

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: (Screen.sizeCategory >= Screen.Large) ? Theme.fontSizeExtraLarge : Theme.fontSizeLarge
            text: ((score < 100) ? qsTr("Game Over!") : qsTr("Congratulations!"))
        }

        Label {
            id: scoreLabel
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeHuge
            font.weight: Font.Bold
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: (Screen.sizeCategory >= Screen.Large) ? Theme.fontSizeLarge : Theme.fontSizeMedium
            text: getTextByScore(score)
        }
    }
}
