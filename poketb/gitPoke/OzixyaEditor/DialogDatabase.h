#ifndef DIALOGDATABASE_H
#define DIALOGDATABASE_H

#include <QString>
#include <QFile>
#include <vector>
#include "Singleton.h"


enum DynamicAnswerType
{
	ITEMS_OWNED,
	CREATURES_OWNED,
	DISCOVERED_MAPS,
	END_DYNAMIC_ANSWER_TYPE
};

class Answer
{
public:
	Answer() : nextDialog(0) {}
	int nextDialog;
};
class StaticAnswer : public Answer
{
public:
	StaticAnswer() : Answer(), text("") {}

	QString text;
};
class DynamicAnswer : public Answer
{
public:
	DynamicAnswer() : Answer(), answerType(END_DYNAMIC_ANSWER_TYPE) {}

	DynamicAnswerType answerType;
};

class Dialog
{
public:
	Dialog() {}
};

class MessageDialog : public Dialog
{
public:
	MessageDialog() : Dialog(), message() {}

	QString message;
	std::vector<Answer*> answers;
};
class StartQuestDialog: public Dialog
{
public:
	StartQuestDialog() : Dialog(), questIndex(0) {}

	int questIndex;
};
class SellItemDialog: public Dialog
{
public:
	SellItemDialog() : Dialog(), itemIndex(0) {}

	int itemIndex;
};


class DialogDatabase : public Singleton<DialogDatabase>
{
	friend class Singleton<DialogDatabase>;
public:
    DialogDatabase();

	void save();
	void load();

private:
	std::vector<Dialog*> dialogs;

};

#endif // DIALOGDATABASE_H
