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
                            DB.saveHighScore(main.currentNumber);
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
            main.noMoreMoves = false;
            cellMatrix.itemAt(lastMove).cellText = '';
            cellMatrix.itemAt(prevMove).cellText = '';
            cellClicked(prevMove);
        } else if (history.length == 1) resetBoard();
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
                onClicked: pageStack.push(Qt.resolvedUrl("HiScoresPage.qml"))
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
            id: container
            width: (parent.width - (2 * Theme.paddingMedium))
            anchors.horizontalCenter: parent.horizontalCenter
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

                        width: (container.width / 10)
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
                visible: (main.currentNumber > 0)
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'Your score is:'
            }

            Label {
                visible: (main.currentNumber > 0)
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeExtraLarge
                font.weight: Font.Bold
                text: main.currentNumber
            }

            Label {
                visible: main.noMoreMoves
                anchors.horizontalCenter: parent.horizontalCenter
                text: "No more moves!"
            }
        }
    }
}
