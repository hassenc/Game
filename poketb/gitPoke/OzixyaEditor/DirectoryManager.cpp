#include "DirectoryManager.h"

DirectoryManager::DirectoryManager()
{
	searchDirectories();
}

QString getDirectory(const QDir* mediaPath, QString folder)
{
	QDir temp(mediaPath->absolutePath()+"/"+folder);
	if (temp.exists())
		return temp.absolutePath()+"/";

	QMessageBox::warning(0, "Directory not found", "The "+folder+" directory has not been found in your media folder.");
	return "";
}

void DirectoryManager::searchDirectories()
{
	QDir mediaPath("../media");
	if (!mediaPath.exists())
		mediaPath.setPath("media");
	if (!mediaPath.exists())
		mediaPath.setPath("../../media");
	if (!mediaPath.exists())
		return;

	mapsDirectory			= getDirectory(&mediaPath, "maps");
	mapTexturesDirectory	= getDirectory(&mediaPath, "maps/textures");
	objectsDirectory		= getDirectory(&mediaPath, "objects");
	dialogsDirectory		= getDirectory(&mediaPath, "story");
}

QString DirectoryManager::getMapsDir()
{
	return mapsDirectory;
}
QString DirectoryManager::getMapTexturesDir()
{
	return mapTexturesDirectory;
}
QString DirectoryManager::getDialogsDir()
{
	return dialogsDirectory;
}
QString DirectoryManager::getObjectsDir()
{
	return objectsDirectory;
}
