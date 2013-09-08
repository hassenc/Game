#ifndef TEXTURESDATABASE_H
#define TEXTURESDATABASE_H

#include <SFML/Graphics.hpp>
#include <QString>
#include <QMessageBox>
#include <QFile>
#include <QObject>
#include "Singleton.h"

struct Texture
{
	sf::Image* texture;
	QString name;
};

class TexturesDatabase : public QObject, public Singleton<TexturesDatabase>
{
	Q_OBJECT;
	friend class Singleton<TexturesDatabase>;

public:
	TexturesDatabase();

	void loadDatabase(QString filename);
	void saveDatabase(QString filename);

	const std::vector<Texture>* getTextures();
	sf::Image* getTexture(QString name);
	int getIndexOf(QString name);
	const Texture* getTextureByIndex(int index);

public slots:
	void setSmoothAll(bool smooth);

public:

	bool mustSave;
	bool hasLoaded;

private:
	std::vector<Texture> textures;
};

#endif // TEXTURESDATABASE_H
