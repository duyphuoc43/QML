import QtQuick
import QtQuick.Layouts

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("StepSlider")
    color: "lightBlue"

    property int numberOfCheckPoints: labels.length
    property int selectedCheckPoint: 0
    property int checkBoxSize: 20
    property int stickWidth: 340
    property var labels: ["Black", "RGB", "Custom"]

    Item {
        width: stickWidth; height: 50
        anchors.centerIn: parent

        Rectangle {
            id: stick
            width: parent.width - checkBoxSize * 2; height: 5
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            radius: 5
        }

        Row {
            id: checkPointsRow
            spacing: (stick.width) / (numberOfCheckPoints - 1) - checkBoxSize
            anchors.bottom: stick.verticalCenter
            anchors.bottomMargin: -checkBoxSize / 2
            anchors.horizontalCenter: stick.horizontalCenter

            Repeater {
                model: numberOfCheckPoints
                Column {
                    spacing: 2

                    Text {
                        id: checkPointLabel
                        width: checkBoxSize
                        text: labels[index]
                        anchors.bottomMargin: -checkBoxSize / 2
                    }

                    Rectangle {
                        id: checkBox
                        width: checkBoxSize
                        height: checkBoxSize
                        radius: width / 2
                        color: "white"
                    }
                }
            }
        }

        Rectangle {
            id: draggablePoint
            anchors.verticalCenter: stick.verticalCenter
            width: checkBoxSize - 6; height: checkBoxSize - 6
            color: "red"
            x: checkPointsRow.x + 3
            radius: width / 2

            MouseArea {
                id: dragArea
                anchors.fill: parent
                drag.axis: Drag.XAxis
                drag.minimumX: checkBoxSize / 2 + 3
                drag.maximumX: stick.width + checkBoxSize / 2 + 3
                drag.target: draggablePoint
                drag.smoothed: true
                drag.threshold: 0

                onReleased: {
                    var stepWidth = (stick.width) / (numberOfCheckPoints - 1);
                    selectedCheckPoint = Math.round((draggablePoint.x - 3) / stepWidth);
                    draggablePoint.x = selectedCheckPoint * stepWidth + checkBoxSize / 2 + 3;
                }
            }

            Behavior on x {
                NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
            }
        }
    }
}
