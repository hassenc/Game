#include "DialogEditor.h"
#include "ui_DialogEditor.h"

DialogEditor::DialogEditor(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::DialogEditor)
{
    ui->setupUi(this);


	QObject::connect(ui->pushButtonAdd, SIGNAL(released()), this, SLOT(addItem()));
	QObject::connect(ui->pushButtonInsertChild, SIGNAL(released()), this, SLOT(insertChild()));
	QObject::connect(ui->pushButtonRemove, SIGNAL(released()), this, SLOT(removeItem()));
	QObject::connect(ui->pushButtonOk, SIGNAL(released()), this, SLOT(close()));
}

DialogEditor::~DialogEditor()
{
    delete ui;
}

void DialogEditor::changeEvent(QEvent *e)
{
    QWidget::changeEvent(e);
    switch (e->type()) {
    case QEvent::LanguageChange:
        ui->retranslateUi(this);
        break;
    default:
        break;
    }
}

void DialogEditor::addItem()
{
	int itemCount = ui->treeWidget->topLevelItemCount();

	QTreeWidgetItem* item = new QTreeWidgetItem(QTreeWidgetItem::Type);
	item->setText(0, "Dialog_"+QString::number(itemCount));
	ui->treeWidget->addTopLevelItem(item);

	QTextEdit* dialog = new QTextEdit();
	dialog->setFixedHeight(60);
	ui->treeWidget->setItemWidget(item, 2, dialog);

	QComboBox* cb = new QComboBox();
	cb->addItem("Message");
	cb->addItem("Start Quest");
	cb->addItem("Sell Item");
	cb->addItem("End");
	ui->treeWidget->setItemWidget(item, 1, cb);

}

void DialogEditor::removeItem()
{
	QTreeWidgetItem* item = ui->treeWidget->currentItem();
	if (!item)
		return;
	delete item;
}

void DialogEditor::insertChild()
{
	QTreeWidgetItem* item = ui->treeWidget->currentItem();
	if (!item)
		return;
	if (item->parent() == NULL) // the item is a top-level item, we insert an answer
	{
		int index = item->childCount();
		QTreeWidgetItem* insert = new QTreeWidgetItem(QTreeWidgetItem::Type);
		insert->setText(0, "Answer_"+QString::number(index));

		item->addChild(insert);

		QComboBox* cb = new QComboBox();
		cb->addItem("Static");
		cb->addItem("Dynamic");
		ui->treeWidget->setItemWidget(insert, 1, cb);

		QWidget* answer = new QWidget();

		QLineEdit* lineEdit= new QLineEdit();
		QGridLayout* layout = new QGridLayout();
		answer->setLayout(layout);
		layout->addWidget(lineEdit, 0, 0);

		QComboBox* cb2 = new QComboBox();
		cb2->addItem("Next Dialog");
		cb2->addItem("Start Quest");
		cb2->addItem("Sell Item");
		cb2->addItem("Change Map");
		layout->addWidget(cb2, 0, 1);
		layout->addWidget(new QSpinBox(), 0, 2);
		layout->addWidget(new QPushButton("Select"), 0, 3);

		ui->treeWidget->setItemWidget(insert, 2, answer);

	}

}
