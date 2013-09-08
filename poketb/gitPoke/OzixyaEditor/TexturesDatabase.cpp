#include "TexturesDatabase.h"

TexturesDatabase::TexturesDatabase() : QObject(NULL)
{
	mustSave = false;
	hasLoaded = false;
}

void TexturesDatabase::setSmoothAll(bool smooth)
{
	for (unsigned int i = 0; i < textures.size(); i++)
	{
		textures[i].texture->SetSmooth(smooth);
	}
}

void TexturesDatabase::loadDatabase(QString filename)
{
	QFile file(filename);
	textures.clear();
	if (file.open(QIODevice::ReadOnly | QIODevice::Text))
	{
		QString empty = file.readLine(); // read the size of the database
		while (!file.atEnd())
		{
			QString text = file.readLine();
			if (text.at(0) != '/' && text.at(0) != '.')
				text.insert(0, "../");
			text.remove(text.size()-1, 1); // remove the newline character
			getTexture(text);
		}
		file.close();
	}
	mustSave = false;
	hasLoaded = true;
}

void TexturesDatabase::saveDatabase(QString filename)
{
	if (filename.indexOf(".otd") == -1)
		filename.append(".otd");
	QFile file(filename);

	if (file.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text))
	{
		QString size = QString::number(textures.size())+"\n";
		file.write(size.toStdString().c_str());
		for (unsigned int i = 0; i < textures.size(); i++)
		{
			QString out = textures[i].name+"\n";
			file.write(out.toStdString().c_str());
		}
		file.close();
	}
	mustSave = false;
}

sf::Image* TexturesDatabase::getTexture(QString name)
{
	if (name == "default")
		return textures[0].texture;

	for (unsigned int i = 0; i < textures.size(); i++)
		if (textures[i].name == name)
			return textures[i].texture;
	// texture hasn't been loaded yet :
	sf::Image* img = new sf::Image();
	if (!img->LoadFromFile(name.toStdString()))
		QMessageBox::information(0, "Image error", QString("Unable to locate image \""+name+"\"."));
	img->SetSmooth(false);
	Texture tex;
	tex.name = name;
	tex.texture = img;
	textures.push_back(tex);
	mustSave = true;
	return img;
}

const std::vector<Texture>* TexturesDatabase::getTextures()
{
	return &textures;
}

int TexturesDatabase::getIndexOf(QString name)
{
	if (name == "default")
		return 0;
	for (unsigned int i = 0; i < textures.size(); i++)
		if (textures[i].name == name)
			return i;
	return 0;
}
const Texture* TexturesDatabase::getTextureByIndex(int index)
{
	if (index < (int)(textures.size()))
		return &textures[index];
	return &textures[0];
}
