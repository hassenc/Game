#ifndef DIRECTORYMANAGER_H
#define DIRECTORYMANAGER_H

#include <QFile>
#include <QString>
#include <QMessageBox>
#include <QInputDialog>
#include <QFileDialog>
#include "Singleton.h"

class DirectoryManager : public Singleton<DirectoryManager>
{
	friend class Singleton<DirectoryManager>;
	public:
		DirectoryManager();

		void searchDirectories();

		QString getMapsDir();
		QString getMapTexturesDir();
		QString getDialogsDir();
		QString getObjectsDir();

	private:
		QString mapsDirectory;
		QString mapTexturesDirectory;
		QString dialogsDirectory;
		QString objectsDirectory;
};

#endif // DIRECTORYMANAGER_H
