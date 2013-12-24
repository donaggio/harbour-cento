import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property string score

    Label {
        width: (parent.width - (2 * Theme.paddingMedium))
        anchors.centerIn: parent
        wrapMode: Text.WordWrap
        text: ((score < 100) ? "Game Over!<br /><br />Your score is: <b>" + score + "</b>" : "Congratulations!<br /><br />You won!") + "<br /><br />Do you whish to start a new game?"
    }
}
