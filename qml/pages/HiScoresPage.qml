/*
  Copyright (C) 2014, 2015 Luca Donaggio
  Contact: Luca Donaggio <donaggio@gmail.com>
  All rights reserved.

  You may use this file under the terms of MIT license
*/
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../lib/dbmanager.js" as DB

Page {
    id: page

    allowedOrientations: Orientation.Portrait

    SilicaListView {
        id: container
        anchors.fill: parent

        header: PageHeader {
            title: qsTr("High Scores")
        }

        ViewPlaceholder {
            enabled: container.count == 0
            text: qsTr("You haven't scored high enough, yet!")
        }

        model: ListModel { id: scoreModel }

        delegate: Item {
            id: scoreItem

            height: Theme.itemSizeMedium
            anchors { left: parent.left; leftMargin: Theme.horizontalPageMargin; right: parent.right; rightMargin: Theme.horizonatalPageMargin }

            Label {
                id: posLabel
                anchors { left: parent.left; baseline: scoreLabel.baseline }
                color: Theme.highlightColor
                text: pos
            }

            Label {
                id: scoreLabel
                anchors { left: posLabel.right; leftMargin: Theme.paddingLarge }
                font.pixelSize: Theme.fontSizeLarge
                font.weight: Font.Bold
                text: score
            }

            Label {
                id: timesLabel
                anchors { baseline: scoreLabel.baseline; left: scoreLabel.right; leftMargin: Theme.paddingMedium; right: parent.right }
                text: qsTr("scored %1 %2").arg(num).arg(((num == 1) ? qsTr("time") : qsTr("times")))
            }

            Label {
                id: lastLabel
                anchors { top: scoreLabel.bottom; left: scoreLabel.left; right: parent.right }
                font.pixelSize: Theme.fontSizeExtraSmall
                text: ((num == 1) ? qsTr("On") : qsTr("Last on")) + " " + last.toLocaleDateString(Qt.locale())
            }
        }

        VerticalScrollDecorator { flickable: container }
    }

    Component.onCompleted: {
        var hs = DB.getHighScores(10);
        for (var i = 0; i < hs.length; i++) {
            scoreModel.append({ "pos": (i + 1), "score": hs[i].score, "num": hs[i].num, "last": new Date(hs[i].last) });
        }
    }
}
