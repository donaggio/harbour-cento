/*
  Copyright (C) 2014 Luca Donaggio
  Contact: Luca Donaggio <donaggio@gmail.com>
  All rights reserved.

  You may use this file under the terms of MIT license
*/
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../lib/dbmanager.js" as DB

Page {
    id: page

    SilicaListView {
        id: container
        anchors.fill: parent

        header: PageHeader {
            title: "High Scores"
        }

        ViewPlaceholder {
            enabled: container.count == 0
            text: "You haven't scored high enough, yet!"
        }

        model: ListModel { id: scoreModel }

        delegate: Item {
            id: scoreItem

            width: (parent.width - (2 * Theme.paddingMedium))
            height: Theme.itemSizeMedium
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                id: posLabel
                anchors.left: parent.left
                anchors.baseline: scoreLabel.baseline
                color: Theme.highlightColor
                text: pos
            }

            Label {
                id: scoreLabel
                anchors.left: posLabel.right
                anchors.leftMargin: Theme.paddingMedium
                font.pixelSize: Theme.fontSizeLarge
                font.weight: Font.Bold
                text: score
            }

            Label {
                id: timesLabel
                anchors.baseline: scoreLabel.baseline
                anchors.left: scoreLabel.right
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingMedium
                text: "scored " + num + " " + ((num == 1) ? "time" : "times")
            }

            Label {
                id: lastLabel
                anchors.top: scoreLabel.bottom
                anchors.left: scoreLabel.left
                anchors.right: parent.right
                font.pixelSize: Theme.fontSizeExtraSmall
                text: ((num == 1) ? "On" : "Last on") + " " + last.toLocaleDateString()
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
