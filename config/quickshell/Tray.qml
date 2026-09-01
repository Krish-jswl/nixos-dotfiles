import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Item {
    id: root

    // The PanelWindow containing this tray.
    // Needed so platform menus know which window to anchor to.
    property var barWindow

    implicitWidth: bg.implicitWidth
    implicitHeight: 24

    visible: SystemTray.items.values.length > 0


    Rectangle {
        id: bg

        height: 24

        implicitWidth: rowLayout.implicitWidth + 14

        radius: height / 2

        color: Theme.bg


        RowLayout {
            id: rowLayout

            anchors.centerIn: parent

            spacing: 4


            Repeater {
                model: SystemTray.items.values

                delegate: Rectangle {
                    required property var modelData

                    width: 22
                    height: 22

                    radius: 11

                    color: mouseArea.containsMouse
                           ? Theme.line
                           : "transparent"


                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }


                    Image {
                        anchors.centerIn: parent

                        width: 15
                        height: 15

                        source: modelData.icon

                        smooth: true
                        asynchronous: true

                        fillMode: Image.PreserveAspectFit
                    }


                    MouseArea {
                        id: mouseArea

                        anchors.fill: parent

                        hoverEnabled: true

                        cursorShape: Qt.PointingHandCursor

                        acceptedButtons:
                            Qt.LeftButton |
                            Qt.RightButton |
                            Qt.MiddleButton


                        onClicked: mouse => {
                            if (mouse.button === Qt.RightButton) {

                                if (modelData.hasMenu) {
                                    // Convert the bottom-left of this tray
                                    // icon into coordinates relative to the
                                    // PanelWindow's content item.
                                    const point =
                                        mapToItem(
                                            root.barWindow.contentItem,
                                            0,
                                            height
                                        )

                                    modelData.display(
                                        root.barWindow,
                                        point.x,
                                        point.y
                                    )
                                }

                            } else if (mouse.button === Qt.MiddleButton) {

                                modelData.secondaryActivate()

                            } else {

                                modelData.activate()
                            }
                        }


                        onWheel: wheelEvent => {
                            modelData.scroll(
                                wheelEvent.angleDelta.y,
                                false
                            )
                        }
                    }
                }
            }
        }
    }
}

