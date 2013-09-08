/********************************************************************************
** Form generated from reading UI file 'MainWindow.ui'
**
** Created: Sun Dec 30 13:32:00 2012
**      by: Qt User Interface Compiler version 4.6.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QCheckBox>
#include <QtGui/QComboBox>
#include <QtGui/QDockWidget>
#include <QtGui/QDoubleSpinBox>
#include <QtGui/QFrame>
#include <QtGui/QGridLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QLineEdit>
#include <QtGui/QMainWindow>
#include <QtGui/QMenu>
#include <QtGui/QMenuBar>
#include <QtGui/QSpinBox>
#include <QtGui/QStatusBar>
#include <QtGui/QTableWidget>
#include <QtGui/QToolBar>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QAction *actionNew;
    QAction *actionSave;
    QAction *actionQuit;
    QAction *actionOpen;
    QAction *actionAddTexturesFolder;
    QAction *actionOpen_Database;
    QAction *actionSave_Database;
    QAction *actionOpen_Database_2;
    QAction *actionSave_Database_2;
    QAction *actionEdit_Dialogs;
    QAction *actionSave_As;
    QWidget *centralWidget;
    QMenuBar *menuBar;
    QMenu *fileMenu;
    QMenu *texturesMenu;
    QMenu *menuDialog;
    QToolBar *mainToolBar;
    QStatusBar *statusBar;
    QDockWidget *InformationDock;
    QWidget *dockWidgetContents_2;
    QGridLayout *gridLayout_2;
    QLabel *label;
    QLineEdit *lineEditMapName;
    QLabel *label_2;
    QLabel *label_3;
    QLabel *label_4;
    QComboBox *comboBoxTileType;
    QComboBox *comboBoxActionType;
    QSpinBox *spinBoxActionParameter;
    QFrame *line;
    QCheckBox *checkBoxEditTileType;
    QCheckBox *checkBoxEditTexture;
    QCheckBox *checkBoxShowGrid;
    QLabel *label_5;
    QLabel *label_6;
    QLabel *label_7;
    QSpinBox *levelSpinBox;
    QLabel *label_9;
    QDoubleSpinBox *doubleSpinBoxWymProbability;
    QCheckBox *showTextCheckBox;
    QLineEdit *lineEditAllowedCreatures;
    QLabel *label_8;
    QDockWidget *TexturesDock;
    QWidget *dockWidgetContents;
    QGridLayout *gridLayout;
    QTableWidget *tableWidget;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(1109, 808);
        actionNew = new QAction(MainWindow);
        actionNew->setObjectName(QString::fromUtf8("actionNew"));
        actionSave = new QAction(MainWindow);
        actionSave->setObjectName(QString::fromUtf8("actionSave"));
        actionQuit = new QAction(MainWindow);
        actionQuit->setObjectName(QString::fromUtf8("actionQuit"));
        actionOpen = new QAction(MainWindow);
        actionOpen->setObjectName(QString::fromUtf8("actionOpen"));
        actionAddTexturesFolder = new QAction(MainWindow);
        actionAddTexturesFolder->setObjectName(QString::fromUtf8("actionAddTexturesFolder"));
        actionOpen_Database = new QAction(MainWindow);
        actionOpen_Database->setObjectName(QString::fromUtf8("actionOpen_Database"));
        actionSave_Database = new QAction(MainWindow);
        actionSave_Database->setObjectName(QString::fromUtf8("actionSave_Database"));
        actionOpen_Database_2 = new QAction(MainWindow);
        actionOpen_Database_2->setObjectName(QString::fromUtf8("actionOpen_Database_2"));
        actionOpen_Database_2->setEnabled(true);
        actionSave_Database_2 = new QAction(MainWindow);
        actionSave_Database_2->setObjectName(QString::fromUtf8("actionSave_Database_2"));
        actionEdit_Dialogs = new QAction(MainWindow);
        actionEdit_Dialogs->setObjectName(QString::fromUtf8("actionEdit_Dialogs"));
        actionSave_As = new QAction(MainWindow);
        actionSave_As->setObjectName(QString::fromUtf8("actionSave_As"));
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QString::fromUtf8("centralWidget"));
        MainWindow->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(MainWindow);
        menuBar->setObjectName(QString::fromUtf8("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 1109, 27));
        fileMenu = new QMenu(menuBar);
        fileMenu->setObjectName(QString::fromUtf8("fileMenu"));
        texturesMenu = new QMenu(menuBar);
        texturesMenu->setObjectName(QString::fromUtf8("texturesMenu"));
        menuDialog = new QMenu(menuBar);
        menuDialog->setObjectName(QString::fromUtf8("menuDialog"));
        menuDialog->setEnabled(false);
        MainWindow->setMenuBar(menuBar);
        mainToolBar = new QToolBar(MainWindow);
        mainToolBar->setObjectName(QString::fromUtf8("mainToolBar"));
        MainWindow->addToolBar(Qt::TopToolBarArea, mainToolBar);
        statusBar = new QStatusBar(MainWindow);
        statusBar->setObjectName(QString::fromUtf8("statusBar"));
        MainWindow->setStatusBar(statusBar);
        InformationDock = new QDockWidget(MainWindow);
        InformationDock->setObjectName(QString::fromUtf8("InformationDock"));
        InformationDock->setBaseSize(QSize(0, 186));
        InformationDock->setFeatures(QDockWidget::DockWidgetFloatable|QDockWidget::DockWidgetMovable);
        dockWidgetContents_2 = new QWidget();
        dockWidgetContents_2->setObjectName(QString::fromUtf8("dockWidgetContents_2"));
        gridLayout_2 = new QGridLayout(dockWidgetContents_2);
        gridLayout_2->setSpacing(6);
        gridLayout_2->setContentsMargins(11, 11, 11, 11);
        gridLayout_2->setObjectName(QString::fromUtf8("gridLayout_2"));
        label = new QLabel(dockWidgetContents_2);
        label->setObjectName(QString::fromUtf8("label"));

        gridLayout_2->addWidget(label, 0, 0, 1, 1);

        lineEditMapName = new QLineEdit(dockWidgetContents_2);
        lineEditMapName->setObjectName(QString::fromUtf8("lineEditMapName"));

        gridLayout_2->addWidget(lineEditMapName, 0, 1, 1, 2);

        label_2 = new QLabel(dockWidgetContents_2);
        label_2->setObjectName(QString::fromUtf8("label_2"));

        gridLayout_2->addWidget(label_2, 5, 0, 1, 1);

        label_3 = new QLabel(dockWidgetContents_2);
        label_3->setObjectName(QString::fromUtf8("label_3"));

        gridLayout_2->addWidget(label_3, 6, 0, 1, 1);

        label_4 = new QLabel(dockWidgetContents_2);
        label_4->setObjectName(QString::fromUtf8("label_4"));

        gridLayout_2->addWidget(label_4, 7, 0, 1, 1);

        comboBoxTileType = new QComboBox(dockWidgetContents_2);
        comboBoxTileType->setObjectName(QString::fromUtf8("comboBoxTileType"));

        gridLayout_2->addWidget(comboBoxTileType, 5, 1, 1, 2);

        comboBoxActionType = new QComboBox(dockWidgetContents_2);
        comboBoxActionType->setObjectName(QString::fromUtf8("comboBoxActionType"));

        gridLayout_2->addWidget(comboBoxActionType, 6, 1, 1, 2);

        spinBoxActionParameter = new QSpinBox(dockWidgetContents_2);
        spinBoxActionParameter->setObjectName(QString::fromUtf8("spinBoxActionParameter"));

        gridLayout_2->addWidget(spinBoxActionParameter, 7, 1, 1, 2);

        line = new QFrame(dockWidgetContents_2);
        line->setObjectName(QString::fromUtf8("line"));
        line->setFrameShape(QFrame::HLine);
        line->setFrameShadow(QFrame::Sunken);

        gridLayout_2->addWidget(line, 4, 0, 1, 3);

        checkBoxEditTileType = new QCheckBox(dockWidgetContents_2);
        checkBoxEditTileType->setObjectName(QString::fromUtf8("checkBoxEditTileType"));
        checkBoxEditTileType->setChecked(true);

        gridLayout_2->addWidget(checkBoxEditTileType, 8, 1, 1, 1);

        checkBoxEditTexture = new QCheckBox(dockWidgetContents_2);
        checkBoxEditTexture->setObjectName(QString::fromUtf8("checkBoxEditTexture"));
        checkBoxEditTexture->setChecked(true);

        gridLayout_2->addWidget(checkBoxEditTexture, 8, 2, 1, 1);

        checkBoxShowGrid = new QCheckBox(dockWidgetContents_2);
        checkBoxShowGrid->setObjectName(QString::fromUtf8("checkBoxShowGrid"));
        checkBoxShowGrid->setChecked(false);

        gridLayout_2->addWidget(checkBoxShowGrid, 9, 1, 1, 1);

        label_5 = new QLabel(dockWidgetContents_2);
        label_5->setObjectName(QString::fromUtf8("label_5"));

        gridLayout_2->addWidget(label_5, 8, 0, 1, 1);

        label_6 = new QLabel(dockWidgetContents_2);
        label_6->setObjectName(QString::fromUtf8("label_6"));

        gridLayout_2->addWidget(label_6, 9, 0, 1, 1);

        label_7 = new QLabel(dockWidgetContents_2);
        label_7->setObjectName(QString::fromUtf8("label_7"));

        gridLayout_2->addWidget(label_7, 1, 0, 1, 1);

        levelSpinBox = new QSpinBox(dockWidgetContents_2);
        levelSpinBox->setObjectName(QString::fromUtf8("levelSpinBox"));
        levelSpinBox->setMinimum(1);

        gridLayout_2->addWidget(levelSpinBox, 1, 1, 1, 2);

        label_9 = new QLabel(dockWidgetContents_2);
        label_9->setObjectName(QString::fromUtf8("label_9"));

        gridLayout_2->addWidget(label_9, 2, 0, 1, 1);

        doubleSpinBoxWymProbability = new QDoubleSpinBox(dockWidgetContents_2);
        doubleSpinBoxWymProbability->setObjectName(QString::fromUtf8("doubleSpinBoxWymProbability"));
        doubleSpinBoxWymProbability->setFrame(true);
        doubleSpinBoxWymProbability->setSpecialValueText(QString::fromUtf8(""));
        doubleSpinBoxWymProbability->setAccelerated(false);
        doubleSpinBoxWymProbability->setDecimals(4);
        doubleSpinBoxWymProbability->setMaximum(1);
        doubleSpinBoxWymProbability->setSingleStep(0.01);
        doubleSpinBoxWymProbability->setValue(0.015);

        gridLayout_2->addWidget(doubleSpinBoxWymProbability, 2, 1, 1, 2);

        showTextCheckBox = new QCheckBox(dockWidgetContents_2);
        showTextCheckBox->setObjectName(QString::fromUtf8("showTextCheckBox"));

        gridLayout_2->addWidget(showTextCheckBox, 9, 2, 1, 1);

        lineEditAllowedCreatures = new QLineEdit(dockWidgetContents_2);
        lineEditAllowedCreatures->setObjectName(QString::fromUtf8("lineEditAllowedCreatures"));

        gridLayout_2->addWidget(lineEditAllowedCreatures, 3, 1, 1, 2);

        label_8 = new QLabel(dockWidgetContents_2);
        label_8->setObjectName(QString::fromUtf8("label_8"));

        gridLayout_2->addWidget(label_8, 3, 0, 1, 1);

        InformationDock->setWidget(dockWidgetContents_2);
        MainWindow->addDockWidget(static_cast<Qt::DockWidgetArea>(1), InformationDock);
        TexturesDock = new QDockWidget(MainWindow);
        TexturesDock->setObjectName(QString::fromUtf8("TexturesDock"));
        TexturesDock->setFeatures(QDockWidget::DockWidgetFloatable|QDockWidget::DockWidgetMovable);
        dockWidgetContents = new QWidget();
        dockWidgetContents->setObjectName(QString::fromUtf8("dockWidgetContents"));
        gridLayout = new QGridLayout(dockWidgetContents);
        gridLayout->setSpacing(6);
        gridLayout->setContentsMargins(11, 11, 11, 11);
        gridLayout->setObjectName(QString::fromUtf8("gridLayout"));
        tableWidget = new QTableWidget(dockWidgetContents);
        tableWidget->setObjectName(QString::fromUtf8("tableWidget"));
        tableWidget->setEditTriggers(QAbstractItemView::NoEditTriggers);
        tableWidget->setSelectionMode(QAbstractItemView::SingleSelection);
        tableWidget->setIconSize(QSize(60, 60));
        tableWidget->horizontalHeader()->setVisible(false);
        tableWidget->horizontalHeader()->setDefaultSectionSize(60);
        tableWidget->verticalHeader()->setVisible(false);
        tableWidget->verticalHeader()->setDefaultSectionSize(60);
        tableWidget->verticalHeader()->setMinimumSectionSize(30);

        gridLayout->addWidget(tableWidget, 0, 0, 1, 1);

        TexturesDock->setWidget(dockWidgetContents);
        MainWindow->addDockWidget(static_cast<Qt::DockWidgetArea>(1), TexturesDock);

        menuBar->addAction(fileMenu->menuAction());
        menuBar->addAction(texturesMenu->menuAction());
        menuBar->addAction(menuDialog->menuAction());
        fileMenu->addAction(actionNew);
        fileMenu->addAction(actionOpen);
        fileMenu->addAction(actionSave);
        fileMenu->addAction(actionSave_As);
        fileMenu->addSeparator();
        fileMenu->addAction(actionQuit);
        texturesMenu->addAction(actionOpen_Database);
        texturesMenu->addAction(actionSave_Database);
        texturesMenu->addSeparator();
        texturesMenu->addAction(actionAddTexturesFolder);
        menuDialog->addAction(actionOpen_Database_2);
        menuDialog->addAction(actionSave_Database_2);
        menuDialog->addSeparator();
        menuDialog->addAction(actionEdit_Dialogs);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "Ozixya Editor (v 2nights)", 0, QApplication::UnicodeUTF8));
        actionNew->setText(QApplication::translate("MainWindow", "New", 0, QApplication::UnicodeUTF8));
        actionNew->setShortcut(QApplication::translate("MainWindow", "Ctrl+N", 0, QApplication::UnicodeUTF8));
        actionSave->setText(QApplication::translate("MainWindow", "Save", 0, QApplication::UnicodeUTF8));
        actionSave->setShortcut(QApplication::translate("MainWindow", "Ctrl+S", 0, QApplication::UnicodeUTF8));
        actionQuit->setText(QApplication::translate("MainWindow", "Quit", 0, QApplication::UnicodeUTF8));
        actionQuit->setShortcut(QApplication::translate("MainWindow", "Ctrl+Q", 0, QApplication::UnicodeUTF8));
        actionOpen->setText(QApplication::translate("MainWindow", "Open", 0, QApplication::UnicodeUTF8));
        actionOpen->setShortcut(QApplication::translate("MainWindow", "Ctrl+O", 0, QApplication::UnicodeUTF8));
        actionAddTexturesFolder->setText(QApplication::translate("MainWindow", "Add Folder", 0, QApplication::UnicodeUTF8));
        actionOpen_Database->setText(QApplication::translate("MainWindow", "Open Database", 0, QApplication::UnicodeUTF8));
        actionSave_Database->setText(QApplication::translate("MainWindow", "Save Database", 0, QApplication::UnicodeUTF8));
        actionOpen_Database_2->setText(QApplication::translate("MainWindow", "Open Database", 0, QApplication::UnicodeUTF8));
        actionSave_Database_2->setText(QApplication::translate("MainWindow", "Save Database", 0, QApplication::UnicodeUTF8));
        actionEdit_Dialogs->setText(QApplication::translate("MainWindow", "Edit Dialogs", 0, QApplication::UnicodeUTF8));
        actionSave_As->setText(QApplication::translate("MainWindow", "Save As", 0, QApplication::UnicodeUTF8));
        actionSave_As->setShortcut(QApplication::translate("MainWindow", "Ctrl+Shift+S", 0, QApplication::UnicodeUTF8));
        fileMenu->setTitle(QApplication::translate("MainWindow", "File", 0, QApplication::UnicodeUTF8));
        texturesMenu->setTitle(QApplication::translate("MainWindow", "Textures", 0, QApplication::UnicodeUTF8));
        menuDialog->setTitle(QApplication::translate("MainWindow", "Dialog", 0, QApplication::UnicodeUTF8));
        InformationDock->setWindowTitle(QApplication::translate("MainWindow", "Map/Tile Information", 0, QApplication::UnicodeUTF8));
        label->setText(QApplication::translate("MainWindow", "Name", 0, QApplication::UnicodeUTF8));
        label_2->setText(QApplication::translate("MainWindow", "Type", 0, QApplication::UnicodeUTF8));
        label_3->setText(QApplication::translate("MainWindow", "Action", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        label_4->setToolTip(QApplication::translate("MainWindow", "Parameter used by the action", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        label_4->setText(QApplication::translate("MainWindow", "Parameter", 0, QApplication::UnicodeUTF8));
        comboBoxTileType->clear();
        comboBoxTileType->insertItems(0, QStringList()
         << QApplication::translate("MainWindow", "Walkable", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("MainWindow", "Block", 0, QApplication::UnicodeUTF8)
        );
        comboBoxActionType->clear();
        comboBoxActionType->insertItems(0, QStringList()
         << QApplication::translate("MainWindow", "None", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("MainWindow", "Change Map", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("MainWindow", "Obtain Object", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("MainWindow", "Start Fight", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("MainWindow", "Start Dialog", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("MainWindow", "No Random", 0, QApplication::UnicodeUTF8)
        );
        checkBoxEditTileType->setText(QApplication::translate("MainWindow", "Type", 0, QApplication::UnicodeUTF8));
        checkBoxEditTexture->setText(QApplication::translate("MainWindow", "Texture", 0, QApplication::UnicodeUTF8));
        checkBoxShowGrid->setText(QApplication::translate("MainWindow", "Grid", 0, QApplication::UnicodeUTF8));
        label_5->setText(QApplication::translate("MainWindow", "Edit", 0, QApplication::UnicodeUTF8));
        label_6->setText(QApplication::translate("MainWindow", "Show", 0, QApplication::UnicodeUTF8));
        label_7->setText(QApplication::translate("MainWindow", "Level", 0, QApplication::UnicodeUTF8));
        levelSpinBox->setSuffix(QString());
        levelSpinBox->setPrefix(QString());
#ifndef QT_NO_TOOLTIP
        label_9->setToolTip(QApplication::translate("MainWindow", "The Wym spawn probability per tile", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        label_9->setText(QApplication::translate("MainWindow", "Wym Proba", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        doubleSpinBoxWymProbability->setToolTip(QApplication::translate("MainWindow", "The Wym spawn probability per tile", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        showTextCheckBox->setText(QApplication::translate("MainWindow", "Text", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        lineEditAllowedCreatures->setToolTip(QApplication::translate("MainWindow", "Format is \"WymID;WymID;WimID...\"", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        lineEditAllowedCreatures->setInputMask(QString());
        lineEditAllowedCreatures->setText(QString());
        label_8->setText(QApplication::translate("MainWindow", "Creatures", 0, QApplication::UnicodeUTF8));
        TexturesDock->setWindowTitle(QApplication::translate("MainWindow", "Textures", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
