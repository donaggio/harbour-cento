/*
  Copyright (C) 2014, 2015 Luca Donaggio
  Contact: Luca Donaggio <donaggio@gmail.com>
  All rights reserved.

  You may use this file under the terms of MIT license
*/

import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.Portrait

    SilicaFlickable {
        id: aboutFlickable

        anchors.fill: parent
        contentHeight: header.height + aboutContainer.height + Theme.paddingLarge

        PageHeader {
            id: header
            title: qsTr("About Cento")
        }

        Column {
            id: aboutContainer

            anchors { top: header.bottom; left: parent.left; leftMargin: Theme.horizontalPageMargin; right: parent.right; rightMargin: Theme.horizontalPageMargin }
            spacing: Theme.paddingLarge

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignRight
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryHighlightColor
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                text: qsTr("Version %1<br/>&copy; 2015 by Luca Donaggio").arg(Qt.application.version)
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: qsTr("<i>Cento</i> is a puzzle game whose goal is to fill a 10 x 10 grid with numbers from 1 to 100 following some simple &quot;movement&quot; rules:<br />
    <ul>
        <li>skip two cells if you want to move horizontally or vertically</li>
        <li>skip one cell if you want to move diagonally</li>
    </ul><br />
    <br />Good luck!")
            }

            SectionHeader {
                text: qsTr("Sources & License")
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap

                text: qsTr("This is an open source project released under the MIT license.\nYou can find its source code, as well as report any issues and feature requests, on this project's page at GitHub.")
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: (Screen.sizeCategory >= Screen.Large) ? Theme.paddingLarge : Theme.paddingSmall

                Button {
                    text: qsTr("Source code")
                    onClicked: Qt.openUrlExternally("https://github.com/donaggio/harbour-cento")
                }

                Button {
                    text: qsTr("Report issues")
                    onClicked: Qt.openUrlExternally("https://github.com/donaggio/harbour-cento/issues")
                }
            }
        }

        VerticalScrollDecorator { flickable: aboutFlickable }
    }
}
