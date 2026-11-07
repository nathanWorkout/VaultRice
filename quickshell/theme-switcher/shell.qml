import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland

ShellRoot {
    property string currentView: "themes"
    property string selectedTheme: ""
    property string selectedWallpaperFolder: ""
    property string themeQuery: ""
    property string wallpaperQuery: ""
    property bool wallpaperLoading: false
    property bool wallpaperLoadFailed: false

    Process {
        id: applyTheme
        running: false
    }

    ListModel { id: wallpaperModel }
    ListModel { id: filteredWallpaperModel }

    ListModel {
        id: themeModel
        ListElement { label: "Catppuccin Mocha";     folder: "catppuccin-mocha";     surface: "#1e1e2e"; accent: "#cba6f7"; textColor: "#cdd6f4"; symbol: "◕" }
        ListElement { label: "Catppuccin Macchiato"; folder: "catppuccin-macchiato"; surface: "#24273a"; accent: "#c6a0f6"; textColor: "#cad3f5"; symbol: "◕" }
        ListElement { label: "Catppuccin Frappé";    folder: "catppuccin-frappe";    surface: "#303446"; accent: "#ca9ee6"; textColor: "#c6d0f5"; symbol: "◕" }
        ListElement { label: "Catppuccin Latte";     folder: "catppuccin-latte";     surface: "#eff1f5"; accent: "#8839ef"; textColor: "#4c4f69"; symbol: "◕" }
        ListElement { label: "Gruvbox";              folder: "gruvbox";              wallpaperFolder: "gruvbox-dark"; surface: "#282828"; accent: "#fabd2f"; textColor: "#ebdbb2"; symbol: "◆" }
        ListElement { label: "Gruvbox Light";        folder: "gruvbox-light";        surface: "#fbf1c7"; accent: "#af3a03"; textColor: "#3c3836"; symbol: "◆" }
        ListElement { label: "Dracula";              folder: "dracula";              surface: "#282a36"; accent: "#ff79c6"; textColor: "#f8f8f2"; symbol: "♛" }
        ListElement { label: "Nord";                 folder: "nord";                 surface: "#2e3440"; accent: "#88c0d0"; textColor: "#eceff4"; symbol: "❄" }
        ListElement { label: "Everforest";           folder: "everforest";           surface: "#2d353b"; accent: "#a7c080"; textColor: "#d3c6aa"; symbol: "❧" }
        ListElement { label: "Tokyo Night";          folder: "tokyo-night";          surface: "#1a1b26"; accent: "#7aa2f7"; textColor: "#c0caf5"; symbol: "☾" }
        ListElement { label: "Tokyo Storm";          folder: "tokyo-storm";          surface: "#24283b"; accent: "#7dcfff"; textColor: "#c0caf5"; symbol: "☁" }
        ListElement { label: "Rosé Pine";            folder: "rose-pine";            surface: "#191724"; accent: "#ebbcba"; textColor: "#e0def4"; symbol: "✿" }
        ListElement { label: "Rosé Pine Moon";       folder: "rose-pine-moon";       surface: "#232136"; accent: "#c4a7e7"; textColor: "#e0def4"; symbol: "☾" }
        ListElement { label: "Rosé Pine Dawn";       folder: "rose-pine-dawn";       surface: "#faf4ed"; accent: "#d7827e"; textColor: "#575279"; symbol: "☼" }
        ListElement { label: "Kanagawa Wave";       folder: "kanagawa-wave";       surface: "#1F1F28"; accent: "#7E9CD8"; textColor: "#DCD7BA"; symbol: "≈" }
        ListElement { label: "Kanagawa Dragon";     folder: "kanagawa-dragon";     surface: "#181616"; accent: "#8BA4B0"; textColor: "#C5C9C5"; symbol: "龍" }
        ListElement { label: "Kanagawa Lotus";      folder: "kanagawa-lotus";      surface: "#F2ECBC"; accent: "#4D699B"; textColor: "#545464"; symbol: "蓮" }
        ListElement { label: "Solarized Dark";      folder: "solarized-dark";      surface: "#002B36"; accent: "#268BD2"; textColor: "#839496"; symbol: "☼" }
        ListElement { label: "Solarized Light";     folder: "solarized-light";     surface: "#FDF6E3"; accent: "#268BD2"; textColor: "#657B83"; symbol: "☀" }
        ListElement { label: "Ayu Mirage";          folder: "ayu-mirage";          surface: "#1F2430"; accent: "#FFCC66"; textColor: "#D3E3FC"; symbol: "◆" }
        ListElement { label: "One Dark";            folder: "one-dark";            surface: "#282C34"; accent: "#61AFEF"; textColor: "#ABB2BF"; symbol: "◒" }
    }

    ListModel { id: filteredThemeModel }

    Component.onCompleted: filterThemeResults()

    function filterThemeResults() {
        filteredThemeModel.clear()
        var query = themeQuery.trim().toLowerCase()
        for (var itemIndex = 0; itemIndex < themeModel.count; itemIndex++) {
            var theme = themeModel.get(itemIndex)
            if ((theme.label + " " + theme.folder).toLowerCase().indexOf(query) !== -1) {
                filteredThemeModel.append({
                    label: theme.label,
                    folder: theme.folder,
                    surface: theme.surface,
                    accent: theme.accent,
                    textColor: theme.textColor,
                    symbol: theme.symbol,
                    wallpaperFolder: theme.wallpaperFolder || theme.folder
                })
            }
        }
        themeRow.currentIndex = filteredThemeModel.count > 0 ? 0 : -1
    }

    function filterWallpaperResults() {
        filteredWallpaperModel.clear()
        var query = wallpaperQuery.trim().toLowerCase()
        for (var itemIndex = 0; itemIndex < wallpaperModel.count; itemIndex++) {
            var wallpaper = wallpaperModel.get(itemIndex)
            if (wallpaper.name.toLowerCase().indexOf(query) !== -1)
                filteredWallpaperModel.append(wallpaper)
        }
        wallpaperGrid.currentIndex = filteredWallpaperModel.count > 0 ? 0 : -1
    }

    function openWallpapers(themeFolder, wallpaperFolder) {
        selectedTheme = themeFolder
        selectedWallpaperFolder = wallpaperFolder || themeFolder
        wallpaperQuery = ""
        wallpaperSearch.text = ""
        wallpaperModel.clear()
        filteredWallpaperModel.clear()
        wallpaperLoadFailed = false
        wallpaperLoading = true
        currentView = "wallpapers"
        Qt.callLater(function() { wallpaperSearch.forceActiveFocus() })
    }

    Process {
        id: lsProcess
        command: ["find", Quickshell.env("HOME") + "/Pictures/Wallpapers/" + selectedWallpaperFolder, "-type", "f", "(", "-iname", "*.png", "-o", "-iname", "*.jpg", "-o", "-iname", "*.jpeg", "-o", "-iname", "*.webp", ")"]
        running: currentView === "wallpapers" && selectedTheme !== ""

        onStarted: {
            wallpaperLoading = true
            wallpaperLoadFailed = false
        }

        onExited: function(exitCode, exitStatus) {
            wallpaperLoading = false
            wallpaperLoadFailed = wallpaperLoadFailed || exitCode !== 0
        }

        stdout: SplitParser {
            onRead: function(data) {
                var p = data.trim()
                var lowerPath = p.toLowerCase()
                if (lowerPath.endsWith(".png") || lowerPath.endsWith(".jpg") || lowerPath.endsWith(".jpeg") || lowerPath.endsWith(".webp")) {
                    wallpaperModel.append({ path: p, name: p.split("/").pop() })
                    filterWallpaperResults()
                }
            }
        }

        stderr: SplitParser {
            onRead: function(data) { wallpaperLoadFailed = true }
        }
    }

    PanelWindow {
        id: root
        anchors { bottom: true }
        implicitWidth: 750
        implicitHeight: currentView === "themes" ? 210 : 500
        focusable: true
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Top
        color: "transparent"

        margins.left: (screen.width - 750) / 2
        margins.right: (screen.width - 750) / 2

        Item {
            id: keyboardHandler
            anchors.fill: parent
            focus: true

            function runApply(wall) {
                applyTheme.exec(["bash", Quickshell.env("HOME") + "/.config/themes/apply-theme.sh", selectedTheme, wall])
            }

            Keys.priority: Keys.AfterItem
            Keys.onEscapePressed: {
                if (currentView === "wallpapers") {
                    if (wallpaperSearch.activeFocus && wallpaperQuery.length > 0) {
                        wallpaperSearch.text = ""
                    } else {
                        currentView = "themes"
                        wallpaperSearch.text = ""
                        wallpaperModel.clear()
                        filteredWallpaperModel.clear()
                        Qt.callLater(function() { keyboardHandler.forceActiveFocus() })
                    }
                } else if (themeSearchInput.activeFocus && themeQuery.length > 0) {
                    themeSearchInput.text = ""
                } else {
                    Qt.quit()
                }
            }
            Keys.onLeftPressed:  if (!wallpaperSearch.activeFocus && !themeSearchInput.activeFocus) currentView === "themes" ? themeRow.decrementCurrentIndex() : wallpaperGrid.moveCurrentIndexLeft()
            Keys.onRightPressed: if (!wallpaperSearch.activeFocus && !themeSearchInput.activeFocus) currentView === "themes" ? themeRow.incrementCurrentIndex() : wallpaperGrid.moveCurrentIndexRight()
            Keys.onUpPressed:    if (currentView === "wallpapers" && !wallpaperSearch.activeFocus && !themeSearchInput.activeFocus) wallpaperGrid.moveCurrentIndexUp()
            Keys.onDownPressed:  if (currentView === "wallpapers" && !wallpaperSearch.activeFocus && !themeSearchInput.activeFocus) wallpaperGrid.moveCurrentIndexDown()
            Keys.onReturnPressed: {
                if (currentView === "themes") {
                    if (filteredThemeModel.count > 0)
                        openWallpapers(filteredThemeModel.get(themeRow.currentIndex).folder, filteredThemeModel.get(themeRow.currentIndex).wallpaperFolder)
                } else if (wallpaperSearch.activeFocus) {
                    wallpaperGrid.forceActiveFocus()
                } else if (wallpaperGrid.currentItem) {
                    runApply(wallpaperGrid.currentItem.wallPath)
                }
            }

            // Vue themes
            Rectangle {
                visible: currentView === "themes"
                anchors.fill: parent
                color: "#2d353b"
                topLeftRadius: 14
                topRightRadius: 14
                bottomLeftRadius: 0
                bottomRightRadius: 0

                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 16
                    text: "Themes"
                    color: "#d3c6aa"
                    opacity: 0.6
                    font.pixelSize: 13
                }

                Rectangle {
                    id: themeSearchBox
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 8
                    anchors.leftMargin: 88
                    anchors.rightMargin: 12
                    height: 34
                    radius: 8
                    color: "#343f44"
                    border.color: themeSearchInput.activeFocus ? "#a7c080" : "#d3c6aa"
                    border.width: 1

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        text: "⌕"
                        color: themeSearchInput.activeFocus ? "#a7c080" : "#d3c6aa"
                        opacity: 0.8
                        font.pixelSize: 19
                    }

                    TextInput {
                        id: themeSearchInput
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: 34
                        anchors.right: themeResultCount.left
                        anchors.rightMargin: 8
                        verticalAlignment: TextInput.AlignVCenter
                        color: "#d3c6aa"
                        font.pixelSize: 12
                        selectByMouse: true
                        clip: true
                        onTextChanged: {
                            themeQuery = text
                            filterThemeResults()
                        }
                    }

                    Text {
                        anchors.left: themeSearchInput.left
                        anchors.verticalCenter: parent.verticalCenter
                        visible: themeSearchInput.text.length === 0
                        text: "Search themes"
                        color: "#d3c6aa"
                        opacity: 0.5
                        font.pixelSize: 12
                    }

                    Text {
                        id: themeResultCount
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        text: filteredThemeModel.count === 0 ? "0/0" : (themeRow.currentIndex + 1) + "/" + filteredThemeModel.count
                        color: "#d3c6aa"
                        opacity: 0.6
                        font.pixelSize: 10
                    }
                }

                ListView {
                    id: themeRow
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 50
                    anchors.bottomMargin: 38
                    orientation: ListView.Horizontal
                    clip: true
                    model: filteredThemeModel
                    spacing: 0
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: width / 2 - 80
                    preferredHighlightEnd: width / 2 + 80
                    highlightMoveDuration: 200

                    delegate: Item {
                        property bool isCurrent: ListView.isCurrentItem
                        width: 160
                        height: themeRow.height

                        Rectangle {
                            anchors.centerIn: parent
                            width: 140
                            height: 84
                            radius: 12
                            scale: isCurrent ? 1.12 : 0.9
                            opacity: isCurrent ? 1.0 : 0.8
                            color: surface
                            border.color: accent
                            border.width: isCurrent ? 2 : 1

                            Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                            Behavior on opacity { NumberAnimation { duration: 150 } }

                            Column {
                                anchors.centerIn: parent
                                width: parent.width - 12
                                spacing: 2

                                Text {
                                    width: parent.width
                                    text: symbol
                                    color: accent
                                    font.pixelSize: 25
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                Text {
                                    width: parent.width
                                    height: 30
                                    text: label
                                    color: textColor
                                    font.pixelSize: 12
                                    font.bold: isCurrent
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (isCurrent) {
                                    openWallpapers(folder, wallpaperFolder)
                                } else {
                                    themeRow.currentIndex = index
                                    keyboardHandler.forceActiveFocus()
                                }
                            }
                        }
                    }
                }

            }

            Rectangle {
                visible: currentView === "wallpapers"
                anchors.fill: parent
                color: "#2d353b"
                topLeftRadius: 12
                topRightRadius: 12
                bottomLeftRadius: 0
                bottomRightRadius: 0

                Rectangle {
                    id: searchBox
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 12
                    height: 42
                    radius: 8
                    color: "#343f44"
                    border.color: wallpaperSearch.activeFocus ? "#a7c080" : "#d3c6aa"
                    border.width: 1

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: "⌕"
                        color: wallpaperSearch.activeFocus ? "#a7c080" : "#d3c6aa"
                        opacity: 0.8
                        font.pixelSize: 22
                    }

                    TextInput {
                        id: wallpaperSearch
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: 38
                        anchors.right: resultCount.left
                        anchors.rightMargin: 8
                        verticalAlignment: TextInput.AlignVCenter
                        color: "#d3c6aa"
                        font.pixelSize: 13
                        selectByMouse: true
                        clip: true
                        onTextChanged: {
                            wallpaperQuery = text
                            filterWallpaperResults()
                        }
                    }

                    Text {
                        anchors.left: wallpaperSearch.left
                        anchors.verticalCenter: parent.verticalCenter
                        visible: wallpaperSearch.text.length === 0
                        text: "Search wallpapers"
                        color: "#d3c6aa"
                        opacity: 0.5
                        font.pixelSize: 13
                    }

                    Text {
                        id: resultCount
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: filteredWallpaperModel.count + "/" + wallpaperModel.count
                        color: "#d3c6aa"
                        opacity: 0.6
                        font.pixelSize: 11
                    }
                }

                Text {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 20
                    visible: filteredWallpaperModel.count === 0
                    text: wallpaperLoading ? "Loading wallpapers..." : wallpaperLoadFailed ? "Unable to read the wallpaper folder" : wallpaperModel.count === 0 ? "No wallpapers found for this theme" : "No wallpapers match your search"
                    color: "#d3c6aa"
                    opacity: 0.55
                    font.pixelSize: 13
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 12
                    color: "#2d353b"
                }

                Rectangle {
                    id: header
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 55
                    color: "#a7c080"

                    Text {
                        anchors.centerIn: parent
                        text: selectedTheme
                        color: "#2d353b"
                        font.pixelSize: 16
                        font.bold: true
                    }
                }

                GridView {
                    id: wallpaperGrid
                    anchors {
                        top: searchBox.bottom
                        left: parent.left
                        right: parent.right
                        bottom: header.top
                    }
                    anchors.topMargin: 8
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.bottomMargin: 10
                    cellWidth: width / 4
                    cellHeight: 120
                    clip: true
                    model: filteredWallpaperModel

                    delegate: Rectangle {
                        property string wallPath: path
                        width: GridView.view.cellWidth - 8
                        height: 112
                        color: GridView.isCurrentItem ? "#343f44" : "#2d353b"
                        radius: 8
                        border.color: GridView.isCurrentItem ? "#a7c080" : "transparent"
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
                                color: "#d3c6aa"
                                font.pixelSize: 10
                                elide: Text.ElideRight
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                GridView.view.currentIndex = index
                                wallpaperGrid.forceActiveFocus()
                            }
                            onDoubleClicked: runApply(path)
                        }
                    }
                }
            }
        }
    }
}
