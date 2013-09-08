/********************************************************************************
** Form generated from reading UI file 'DialogEditor.ui'
**
** Created: Sun Dec 30 13:32:00 2012
**      by: Qt User Interface Compiler version 4.6.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_DIALOGEDITOR_H
#define UI_DIALOGEDITOR_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QGridLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QPushButton>
#include <QtGui/QSpacerItem>
#include <QtGui/QTreeWidget>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_DialogEditor
{
public:
    QGridLayout *gridLayout;
    QPushButton *pushButtonOk;
    QSpacerItem *horizontalSpacer;
    QPushButton *pushButtonAdd;
    QPushButton *pushButtonInsertChild;
    QPushButton *pushButtonRemove;
    QTreeWidget *treeWidget;

    void setupUi(QWidget *DialogEditor)
    {
        if (DialogEditor->objectName().isEmpty())
            DialogEditor->setObjectName(QString::fromUtf8("DialogEditor"));
        DialogEditor->resize(1340, 437);
        gridLayout = new QGridLayout(DialogEditor);
        gridLayout->setObjectName(QString::fromUtf8("gridLayout"));
        pushButtonOk = new QPushButton(DialogEditor);
        pushButtonOk->setObjectName(QString::fromUtf8("pushButtonOk"));

        gridLayout->addWidget(pushButtonOk, 1, 4, 1, 1);

        horizontalSpacer = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout->addItem(horizontalSpacer, 1, 3, 1, 1);

        pushButtonAdd = new QPushButton(DialogEditor);
        pushButtonAdd->setObjectName(QString::fromUtf8("pushButtonAdd"));

        gridLayout->addWidget(pushButtonAdd, 1, 0, 1, 1);

        pushButtonInsertChild = new QPushButton(DialogEditor);
        pushButtonInsertChild->setObjectName(QString::fromUtf8("pushButtonInsertChild"));

        gridLayout->addWidget(pushButtonInsertChild, 1, 1, 1, 1);

        pushButtonRemove = new QPushButton(DialogEditor);
        pushButtonRemove->setObjectName(QString::fromUtf8("pushButtonRemove"));

        gridLayout->addWidget(pushButtonRemove, 1, 2, 1, 1);

        treeWidget = new QTreeWidget(DialogEditor);
        treeWidget->setObjectName(QString::fromUtf8("treeWidget"));
        treeWidget->setDragEnabled(false);
        treeWidget->setDragDropMode(QAbstractItemView::NoDragDrop);

        gridLayout->addWidget(treeWidget, 0, 0, 1, 5);


        retranslateUi(DialogEditor);

        QMetaObject::connectSlotsByName(DialogEditor);
    } // setupUi

    void retranslateUi(QWidget *DialogEditor)
    {
        DialogEditor->setWindowTitle(QApplication::translate("DialogEditor", "Dialog Editor", 0, QApplication::UnicodeUTF8));
        pushButtonOk->setText(QApplication::translate("DialogEditor", "Ok", 0, QApplication::UnicodeUTF8));
        pushButtonAdd->setText(QApplication::translate("DialogEditor", "+", 0, QApplication::UnicodeUTF8));
        pushButtonInsertChild->setText(QApplication::translate("DialogEditor", " \\->", 0, QApplication::UnicodeUTF8));
        pushButtonRemove->setText(QApplication::translate("DialogEditor", "-", 0, QApplication::UnicodeUTF8));
        QTreeWidgetItem *___qtreewidgetitem = treeWidget->headerItem();
        ___qtreewidgetitem->setText(2, QApplication::translate("DialogEditor", "Value", 0, QApplication::UnicodeUTF8));
        ___qtreewidgetitem->setText(1, QApplication::translate("DialogEditor", "Type", 0, QApplication::UnicodeUTF8));
        ___qtreewidgetitem->setText(0, QApplication::translate("DialogEditor", "Tree", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class DialogEditor: public Ui_DialogEditor {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_DIALOGEDITOR_H
