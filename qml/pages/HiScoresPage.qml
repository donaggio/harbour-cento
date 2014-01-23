/*
  Copyright (C) 2014 Luca Donaggio
  Contact: Luca Donaggio <donaggio@gmail.com>
  All rights reserved.

  You may use this file under the terms of MIT license
*/
import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

Page {
    id: page

    Column {
        id: container
        width: (parent.width - (2 * Theme.paddingMedium))
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Theme.paddingLarge

        PageHeader {
            title: "High Scores"
        }

        Component {
            id: scoreItem

            Item {
                property alias pos: posLabel.text
                property alias score: scoreLabel.text
                property int num
                property date last

                width: parent.width
                height: Theme.itemSizeMedium

                Label {
                    id: posLabel
                    anchors.left: parent.left
                    anchors.baseline: scoreLabel.baseline
                    color: Theme.highlightColor
                }

                Label {
                    id: scoreLabel
                    anchors.top: parent.top
                    anchors.left: posLabel.right
                    anchors.leftMargin: Theme.paddingMedium
                    font.pixelSize: Theme.fontSizeLarge
                    font.weight: Font.Bold
                }

                Label {
                    id: timesLabel
                    anchors.baseline: scoreLabel.baseline
                    anchors.left: scoreLabel.right
                    anchors.right: parent.right
                    anchors.leftMargin: Theme.paddingMedium
                    text: "scored " + parent.num + " " + ((parent.num == 1) ? "time" : "times")
                }

                Label {
                    id: lastLabel
                    anchors.top: scoreLabel.bottom
                    anchors.left: scoreLabel.left
                    anchors.right: parent.right
                    font.pixelSize: Theme.fontSizeExtraSmall
                    text: ((parent.num == 1) ? "On" : "Last on") + " " + parent.last.toLocaleDateString()
                }
            }
        }
    }

    Component.onCompleted: {
        try {
            main.db.readTransaction(
                function(tx) {
                    // Get top 10 high scores
                    var rs = tx.executeSql('SELECT score,count(*) as num,max(date) as last FROM hiscore group by score order by score desc limit 5');
                    // Build the ListModel
                    for(var i = 0; i < rs.rows.length; i++) {
                        scoreItem.createObject(container, { "pos": (i + 1), "score": rs.rows.item(i).score, "num": rs.rows.item(i).num, "last": rs.rows.item(i).last });
                    }
                }
            );
        } catch (error) {
            console.log(error);
        }
    }
}
