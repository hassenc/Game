#ifndef DIALOGEDITOR_H
#define DIALOGEDITOR_H

#include <QWidget>
#include <QComboBox>
#include <QTextEdit>
#include <QLineEdit>
#include <QGridLayout>
#include <QSpinBox>
#include <QLabel>

namespace Ui {
    class DialogEditor;
}

class DialogEditor : public QWidget {
    Q_OBJECT
public:
    DialogEditor(QWidget *parent = 0);
    ~DialogEditor();

public slots:
	void addItem();
	void removeItem();
	void insertChild();


protected:
    void changeEvent(QEvent *e);

private:
    Ui::DialogEditor *ui;
};

#endif // DIALOGEDITOR_H
