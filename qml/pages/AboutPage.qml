/*
  Copyright (C) 2014 Luca Donaggio
  Contact: Luca Donaggio <donaggio@gmail.com>
  All rights reserved.

  You may use this file under the terms of MIT license
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    Column {
        width: (parent.width - (2 * Theme.paddingMedium))
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Theme.paddingLarge

        PageHeader {
            title: qsTr("About Cento")
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignRight
            font.pixelSize: Theme.fontSizeSmall
            font.italic: true
            text: qsTr("Version %1").arg(version)
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
    }
}
