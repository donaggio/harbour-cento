/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

Page {
    id: page
    property var history: []

    function indexToCoord(cellIndex) {
        var coord = { "col": (cellIndex % 10), "row": Math.floor(cellIndex / 10) };
        return coord;
    }

    function coordToIndex(coord) {
        var cellIndex = (coord.row >=0 && coord.row <= 9 && coord.col >=0 && coord.col <= 9) ? (coord.row * 10) + coord.col : -1;
        return cellIndex;
    }

    function validDestIndexes(cellIndex) {
        var currCoord = indexToCoord(cellIndex);
        var destOffsets = [{ 'ox': -3, 'oy':  0},
                           { 'ox':  0, 'oy':  3},
                           { 'ox':  3, 'oy':  0},
                           { 'ox':  0, 'oy': -3},
                           { 'ox': -2, 'oy':  2},
                           { 'ox':  2, 'oy':  2},
                           { 'ox':  2, 'oy': -2},
                           { 'ox': -2, 'oy': -2}] // N, E, S, W, NE, SE, SW, NW
        var destIndexes = [];
        var tmpIndex;
        for (var i = 0, l = destOffsets.length; i < l; i++) {
            tmpIndex = coordToIndex( { "row": (currCoord.row + destOffsets[i].ox), "col": (currCoord.col + destOffsets[i].oy) } );
            if ((tmpIndex >= 0) && !cellMatrix.itemAt(tmpIndex).cellText) destIndexes.push(tmpIndex);
        }

        return destIndexes;
    }

    function cellClicked(cellIndex) {
        history.push(cellIndex);
        for (var i = 0; i < cellMatrix.count; i++) {
            cellMatrix.itemAt(i).cellGlowing = false;
            cellMatrix.itemAt(i).color = "transparent";
            cellMatrix.itemAt(i).cellClickable = false;
        }
        cellMatrix.itemAt(cellIndex).cellText = ++main.currentNumber;
        cellMatrix.itemAt(cellIndex).color = Qt.darker(Theme.highlightColor, 1.5);

        var destIndexes = validDestIndexes(cellIndex);
        if (destIndexes.length > 0) {
            for (i in destIndexes) {
                cellMatrix.itemAt(destIndexes[i]).cellGlowing = true;
                cellMatrix.itemAt(destIndexes[i]).cellClickable = true;
            }
        } else {
            main.noMoreMoves = true;
            var dialog = pageStack.push(Qt.resolvedUrl("../dialogs/GameOverDialog.qml"), { "score": main.currentNumber });
            dialog.accepted.connect(
                        function() {
                            saveHighScore(main.currentNumber);
                            resetBoard();
                        }
            );
        }
    }

    function resetBoard() {
        for (var i = 0; i < cellMatrix.count; i++) {
            cellMatrix.itemAt(i).cellText = '';
            cellMatrix.itemAt(i).cellGlowing = false;
            cellMatrix.itemAt(i).color = "transparent";
            cellMatrix.itemAt(i).cellClickable = true;
        }
        history = [];
        main.currentNumber = 0;
        main.noMoreMoves = false;
    }

    function historyBack() {
        if (history.length > 1) {
            var lastMove = history.pop();
            var prevMove = history.pop();
            main.currentNumber = (main.currentNumber - 2);
            cellMatrix.itemAt(lastMove).cellText = '';
            cellMatrix.itemAt(prevMove).cellText = '';
            cellClicked(prevMove);
        } else if (history.length == 1) resetBoard();
    }

    function saveHighScore(score) {
        var db = LocalStorage.openDatabaseSync("CentoDB", "1.0", "Cento High Scores", 1000000);

        db.transaction(
            function(tx) {
                // Create the database if it doesn't already exist
                tx.executeSql('CREATE TABLE IF NOT EXISTS hiscore(date DATE, score INT)');

                // Insert current score
                var today = new Date();
                var todayString = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();
                tx.executeSql('INSERT INTO hiscore VALUES(?, ?)', [ todayString, score ]);
            }
        )
    }

    function getHighScores() {
        var db = LocalStorage.openDatabaseSync("CentoDB", "1.0", "Cento High Scores", 1000000);

        db.transaction(
            function(tx) {
                try {
                    // Get top 10 high scores
                    var rs = tx.executeSql('SELECT * FROM hiscore order by score desc,date desc limit 10');

                    var r = "";
                    for(var i = 0; i < rs.rows.length; i++) {
                        r += rs.rows.item(i).date + " " + rs.rows.item(i).score + "\n";
                    }
                    // DEBUG
                    console.log(r);
                } catch (error) {
                    // Probably the table has not been created yet
                }
            }
        )
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: childrenRect.height

        PullDownMenu {
            MenuItem {
                text: "About Cento"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"), { "version": main.version })
            }
            MenuItem {
                text: "High Scores"
                onClicked: getHighScores();
            }
            MenuItem {
                text: "Reset board"
                onClicked: resetBoard();
            }
            MenuItem {
                visible: (main.currentNumber > 0)
                text: "Undo last move"
                onClicked: historyBack();
            }
        }

        Column {
            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: "Cento"
            }

            Grid {
                rows: 10
                columns: 10
                spacing: 0
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    id: cellMatrix
                    model: 100

                    Rectangle {
                        id: cellContainer
                        property alias cellText: cellContent.text
                        property alias cellClickable: cellMouseArea.enabled
                        property bool cellGlowing: false

                        width: ((page.width - (2 * Theme.paddingSmall)) / 10)
                        height: width
                        color: "transparent"
                        border.color: Theme.highlightColor
                        border.width: 1

                        Label {
                            id: cellContent
                            text: ''
                            font.pointSize: Theme.fontSizeExtraSmall
                            anchors.centerIn: parent
                        }

                        MouseArea { id: cellMouseArea; enabled: enabled; anchors.fill: parent; onClicked: cellClicked(index); }

                        SequentialAnimation on color {
                            id: cellAnimation
                            running: Qt.application.active && cellGlowing
                            loops: Animation.Infinite

                            ColorAnimation { to: Qt.darker(Theme.highlightColor, 1.5); duration: 1000; }
                            ColorAnimation { to: "transparent"; duration: 1000; }
                        }
                    }
                }
            }

            Label {
                id: scoreLabel
                width: (parent.width - (2 * Theme.paddingMedium))
                anchors.horizontalCenter: parent.horizontalCenter
                text: ((main.currentNumber > 0) ? 'You score: ' + main.currentNumber : '') + (main.noMoreMoves ? '<br /><br />No more moves!' : '')
            }
        }
    }
}
