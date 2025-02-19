import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../component"

Rectangle {
    id: root
    width: stickWidth
    height: 50
    color: "transparent"

    property int numberOfCheckPoints: labels.length
    property int selectedCheckPoint: 0
    property int checkBoxSize: 20
    property int stickWidth: 340
    property var labels: ["A", "B", "C"]
    property int stepWidth: (stickWidth - checkBoxSize * 2) / (numberOfCheckPoints - 1)

    Rectangle {
        width: stickWidth
        height: root.height
        color: "transparent"
        anchors.top: parent.top
        anchors.topMargin: 10

        Rectangle {
            id: stick
            width: parent.width - checkBoxSize * 2
            height: 5
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            radius: 5
        }

        Row {
            id: checkPointsRow
            spacing: stick.width / (numberOfCheckPoints - 1) - checkBoxSize
            anchors.bottom: stick.verticalCenter
            anchors.bottomMargin: -checkBoxSize / 2
            anchors.horizontalCenter: stick.horizontalCenter

            Repeater {
                model: numberOfCheckPoints
                Column {
                    spacing: 10

                    Text {
                        id: checkPointLabel
                        width: parent.width
                        height: checkBoxSize / 2
                        text: labels[index]
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Rectangle {
                        id: checkBox
                        width: checkBoxSize
                        height: checkBoxSize
                        radius: width / 2
                        color: "white"

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                timeAnimation.duration = 1
                                root.selectedCheckPoint = index
                                draggablePoint.x = calculateDraggablePointPosition()
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: draggablePoint
            anchors.verticalCenter: stick.verticalCenter
            width: checkBoxSize - 6
            height: checkBoxSize - 6
            color: "red"
            x: calculateDraggablePointPosition()
            radius: width / 2

            MouseArea {
                id: dragArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                drag.axis: Drag.XAxis
                drag.minimumX: checkBoxSize / 2 + 3
                drag.maximumX: stick.width + checkBoxSize / 2 + 3
                drag.target: draggablePoint
                drag.smoothed: true
                drag.threshold: 0

                onReleased: {
                    timeAnimation.duration = 200;
                    root.stepWidth = stick.width / (numberOfCheckPoints - 1);
                    selectedCheckPoint = Math.round((draggablePoint.x - 3) / root.stepWidth);
                    draggablePoint.x = calculateDraggablePointPosition()
                }
            }

            Behavior on x {
                NumberAnimation {
                    id:timeAnimation
                    easing.type: Easing.OutQuad
                }
            }
        }
    }
    function calculateDraggablePointPosition() {
        return selectedCheckPoint * root.stepWidth + checkBoxSize / 2 + 3
    }
}
