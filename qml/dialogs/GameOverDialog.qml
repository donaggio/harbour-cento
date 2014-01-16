import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property string score

    Column {
        spacing: Theme.paddingLarge
        anchors.fill: parent

        DialogHeader {
            acceptText: "Start new game"
        }

        Label {
            visible: (score < 100)
            width: (parent.width - (2 * Theme.paddingMedium))
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WordWrap
            text: "Game Over!<br /><br />Your score is: <b>" + score + "</b>"
        }

        Label {
            visible: (score == 100)
            width: (parent.width - (2 * Theme.paddingMedium))
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WordWrap
            text: "Congratulations!\n\nYou won!"
        }
    }
}
