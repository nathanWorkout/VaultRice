import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland

ShellRoot {
    property string currentView: "themes"
    property string selectedTheme: ""

    Process {
        id: applyTheme
        running: false
    }

    ListModel { id: wallpaperModel }

    Process {
        id: lsProcess
        command: ["find", "/home/nathan/Pictures/Wallpapers/" + selectedTheme, "-type", "f"]
        running: currentView === "wallpapers"

        stdout: SplitParser {
            onRead: function(data) {
                var p = data.trim()
                if (p.endsWith(".png") || p.endsWith(".jpg") || p.endsWith(".jpeg"))
                    wallpaperModel.append({ path: p, name: p.split("/").pop() })
            }
        }
    }

    PanelWindow {
        id: root
        anchors { bottom: true }
        implicitWidth: 750
        implicitHeight: currentView === "themes" ? 300 : 500
        focusable: true
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Top
        color: "transparent"

        margins.left: (screen.width - 750) / 2
        margins.right: (screen.width - 750) / 2

        Item {
            anchors.fill: parent
            focus: true

            function runApply(wall) {
                applyTheme.exec(["bash", "/home/nathan/.config/themes/apply-theme.sh", selectedTheme, wall])
            }

            Keys.onEscapePressed: {
                if (currentView === "wallpapers") {
                    currentView = "themes"
                    wallpaperModel.clear()
                } else {
                    Qt.quit()
                }
            }
            Keys.onUpPressed:    currentView === "themes" ? themeGrid.moveCurrentIndexUp()    : wallpaperGrid.moveCurrentIndexUp()
            Keys.onDownPressed:  currentView === "themes" ? themeGrid.moveCurrentIndexDown()  : wallpaperGrid.moveCurrentIndexDown()
            Keys.onLeftPressed:  currentView === "themes" ? themeGrid.moveCurrentIndexLeft()  : wallpaperGrid.moveCurrentIndexLeft()
            Keys.onRightPressed: currentView === "themes" ? themeGrid.moveCurrentIndexRight() : wallpaperGrid.moveCurrentIndexRight()
            Keys.onReturnPressed: {
                if (currentView === "themes") {
                    selectedTheme = themeGrid.currentItem.themeName
                    currentView = "wallpapers"
                } else {
                    runApply(wallpaperGrid.currentItem.wallPath)
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "QBG"
                radius: 12

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 12
                    color: "QBG"
                }

                Rectangle {
                    id: header
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 55
                    color: "QACCENT"

                    Text {
                        anchors.centerIn: parent
                        text: currentView === "themes" ? "Theme" : selectedTheme
                        color: "QBG"
                        font.pixelSize: 16
                        font.bold: true
                    }
                }

                GridView {
                    id: themeGrid
                    visible: currentView === "themes"
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        bottom: header.top
                    }
                    anchors.margins: 10
                    cellWidth: width / 3
                    cellHeight: 60
                    focus: currentView === "themes"

                    model: ListModel {
                      ListElement { name: "Gruvbox";          folder: "gruvbox" }
                      ListElement { name: "Catppuccin Mocha"; folder: "catppuccin-mocha" }
                      ListElement { name: "Nord";             folder: "nord" }
}

                    delegate: Rectangle {
                        property string themeName: folder
                        width: GridView.view.cellWidth - 10
                        height: 50
                        color: GridView.isCurrentItem ? "QBGALT" : "QBG"
                        radius: 10
                        border.color: GridView.isCurrentItem ? "QACCENT" : "transparent"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: name
                            color: GridView.isCurrentItem ? "QACCENT" : "QFG"
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                GridView.view.currentIndex = index
                                selectedTheme = folder
                                currentView = "wallpapers"
                            }
                        }
                    }
                }

                GridView {
                    id: wallpaperGrid
                    visible: currentView === "wallpapers"
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        bottom: header.top
                    }
                    anchors.margins: 10
                    cellWidth: width / 4
                    cellHeight: 120
                    focus: currentView === "wallpapers"

                    model: wallpaperModel

                    delegate: Rectangle {
                        property string wallPath: path
                        width: GridView.view.cellWidth - 8
                        height: 112
                        color: GridView.isCurrentItem ? "QBGALT" : "QBG"
                        radius: 8
                        border.color: GridView.isCurrentItem ? "QACCENT" : "transparent"
                        border.width: 1

                        Column {
                            anchors.fill: parent
                            anchors.margins: 4
                            spacing: 4

                            Image {
                                width: parent.width
                                height: parent.height - 22
                                source: "file://" + path
                                fillMode: Image.PreserveAspectCrop
                            }

                            Text {
                                width: parent.width
                                text: name
                                color: "QFG"
                                font.pixelSize: 10
                                elide: Text.ElideRight
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: GridView.view.currentIndex = index
                            onDoubleClicked: runApply(path)
                        }
                    }
                }
            }
        }
    }
}
