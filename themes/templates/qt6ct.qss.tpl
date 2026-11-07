QWidget {
    color: QFG;
}

QMainWindow,
QDialog {
    background-color: QBG;
}

DolphinView,
KItemListContainer,
KItemListContainerViewport,
QGraphicsView,
QGraphicsView::viewport,
QAbstractScrollArea::viewport,
QWidget#qt_scrollarea_viewport,
QAbstractScrollArea QWidget {
    background-color: QBG;
    background: QBG;
    color: QFG;
}

QToolBar,
QMenuBar,
QStatusBar {
    background-color: QBGALT;
    color: QFG;
    border: 0;
    spacing: 4px;
}

QToolBar {
    padding: 4px;
}

QAbstractItemView,
QTreeView,
QListView,
QTableView {
    background-color: QBG;
    alternate-background-color: QBGALT;
    color: QFG;
    selection-background-color: QACCENT;
    selection-color: ACCENT_FG;
    border: 1px solid DIR_BG;
    outline: 0;
}

QHeaderView::section {
    background-color: QBGALT;
    color: QFG;
    border: 0;
    border-right: 1px solid DIR_BG;
    border-bottom: 1px solid DIR_BG;
    padding: 6px 8px;
}

QLineEdit,
QComboBox,
QSpinBox,
QDoubleSpinBox,
QTextEdit,
QPlainTextEdit {
    background-color: QBGALT;
    color: QFG;
    selection-background-color: QACCENT;
    selection-color: ACCENT_FG;
    border: 1px solid DIR_BG;
    border-radius: 5px;
    padding: 5px 7px;
}

QPushButton,
QToolButton {
    background-color: QBGALT;
    color: QFG;
    border: 1px solid DIR_BG;
    border-radius: 5px;
    padding: 5px 8px;
}

QPushButton:hover,
QToolButton:hover,
QMenu::item:selected,
QTabBar::tab:hover {
    background-color: QACCENT;
    color: ACCENT_FG;
}

QPushButton:pressed,
QToolButton:pressed {
    background-color: QACCENT;
    color: ACCENT_FG;
}

QTabWidget::pane {
    background-color: QBG;
    border: 1px solid DIR_BG;
    top: -1px;
}

QTabBar::tab {
    background-color: QBGALT;
    color: QFG;
    border: 1px solid DIR_BG;
    border-bottom: 0;
    padding: 7px 12px;
    margin-right: 2px;
}

QTabBar::tab:selected {
    background-color: QBG;
    color: QACCENT;
    border-bottom: 2px solid QACCENT;
}

QMenu {
    background-color: QBGALT;
    color: QFG;
    border: 1px solid DIR_BG;
    padding: 4px;
}

QMenu::item {
    padding: 6px 24px 6px 10px;
    border-radius: 3px;
}

QToolTip {
    background-color: QBGALT;
    color: QFG;
    border: 1px solid QACCENT;
    padding: 4px 6px;
}

QScrollBar:vertical {
    width: 10px;
    background-color: QBG;
    margin: 2px;
}

QScrollBar:horizontal {
    height: 10px;
    background-color: QBG;
    margin: 2px;
}

QScrollBar::handle:vertical,
QScrollBar::handle:horizontal {
    background-color: DIR_BG;
    border-radius: 4px;
    min-height: 24px;
    min-width: 24px;
}

QScrollBar::handle:vertical:hover,
QScrollBar::handle:horizontal:hover {
    background-color: QACCENT;
}

QScrollBar::add-line,
QScrollBar::sub-line,
QScrollBar::add-page,
QScrollBar::sub-page {
    background: transparent;
    border: 0;
}

QProgressBar {
    background-color: QBGALT;
    color: QFG;
    border: 1px solid DIR_BG;
    border-radius: 4px;
    text-align: center;
}

QProgressBar::chunk {
    background-color: QACCENT;
    border-radius: 3px;
}
