#include "MySFMLCanvas.h"

MyCanvas::MyCanvas(QWidget* Parent, const QPoint& Position, const QSize& Size) : QSFMLCanvas(Parent, Position, Size)
{
	mapLoaded = false;
	currentTexture="default";
	hasBeenModifiedSinceLastSave = false;
	for (int i = 0; i < 12; i++)
		for (int j = 0; j < 18; j++)
			sprites[i][j] = NULL;

	currentTileInfo.type = 0;
	currentTileInfo.actionParameter = 0;
	currentTileInfo.actionType = 0;
	mustEditTileType = true;
	mustEditTileTexture = true;
	showStrings = false;
	mapLevel = 1;
	wymProbability = 0.015;
	possibleWyms = "";
}

void MyCanvas::loadEmptyMap()
{

	for (int i = 0; i < 12; i++)
	{
		for (int j = 0; j < 18; j++)
		{
			if (sprites[i][j]) delete sprites[i][j];
			sprites[i][j] = new sf::Sprite();
			sprites[i][j]->SetImage(*TexturesDatabase::getInstance()->getTexture("default"));
			sprites[i][j]->Resize(tileWidth, tileHeight*2);
			sprites[i][j]->SetPosition(tileWidth*j, tileHeight*(i-1));
			spritesTextures[i][j] = "default";


			if (strings[i][j]) delete strings[i][j];
			strings[i][j] = new sf::String();
			strings[i][j]->SetText("0\n0\n0");
			strings[i][j]->SetSize(12.f);
			strings[i][j]->SetPosition(tileWidth*j+tileWidth/2, tileHeight*i+tileHeight/5);
		}
	}
	mapLoaded = true;
	mapLevel = 1;
	wymProbability = 0.015;
	possibleWyms = "";
}

void MyCanvas::setCurrentTexture(QString tex)
{
	currentTexture = tex;
}
void MyCanvas::setCurrentTileType(int value)
{
	currentTileInfo.type = value;
}
void MyCanvas::setCurrentTileAction(int value)
{
	currentTileInfo.actionType = value;
}
void MyCanvas::setCurrentTileActionParameter(int value)
{
	currentTileInfo.actionParameter = value;
}
void MyCanvas::editTileType(bool val)
{
	mustEditTileType = val;
}
void MyCanvas::editTileTexture(bool val)
{
	mustEditTileTexture = val;
}

QString MyCanvas::getTileRelatedString(int x, int y)
{
	QString posX			= "";
	QString posY			= "";
	QString texture			= "";
	QString type			= QString::number(tilesInfo[y][x].type);
	QString action			= QString::number(tilesInfo[y][x].actionType);
	QString actionParameter = "";

	// positions
	if (x/10 == 0) posX="0";
		posX += QString::number(x);
	if (y/10 == 0) posY="0";
		posY += QString::number(y);

	// texture
	int texIndex = TexturesDatabase::getInstance()->getIndexOf(spritesTextures[y][x]);
	if (texIndex/100 == 0) texture+="0";
	if (texIndex/10 == 0) texture+="0";
	texture += QString::number(texIndex);

	// tile infos
	if (tilesInfo[y][x].actionParameter/100 == 0) actionParameter += "0";
	if (tilesInfo[y][x].actionParameter/10 == 0) actionParameter += "0";
	actionParameter += QString::number(tilesInfo[y][x].actionParameter);

	return posX+posY+texture+type+action+actionParameter;
}

void MyCanvas::saveMap(QString filename, QString mapName)
{
	if (filename.indexOf(".om") == -1)
		filename.append(".om");
	QFile file(filename);
	if (file.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text))
	{
		QString line = "P_Name= \"" + mapName + "\"\n";
		file.write(line.toStdString().c_str());
		line = "P_Level= \"" + QString::number(mapLevel) + "\"\n";
		file.write(line.toStdString().c_str());
		line = "P_WymProba= \"" + QString::number(wymProbability) + "\"\n";
		file.write(line.toStdString().c_str());
		line = "P_Creatures= \"" + this->possibleWyms + "\"\n";
		file.write(line.toStdString().c_str());
		file.write("P_Def= \"");
		for (int i = 0; i < 12; i++)
		{
			for (int j = 0; j < 18; j++)
			{
				QString entry = getTileRelatedString(j,i);
				if (i != 11 || j != 17)
					entry += " ";
				file.write(entry.toStdString().c_str());
			}
		}
		file.write("\"");
		file.close();
	}
	hasBeenModifiedSinceLastSave = false;

}

QString MyCanvas::loadMap(QString filename) // load the map and returns its name
{
	QString name = "";
	QString def = "";
	int level = 1;
	float proba = 0.f;
	QString possibleCreatures = "";
	QFile file(filename);
	if (file.open(QIODevice::ReadOnly | QIODevice::Text))
	{
		while (!file.atEnd())
		{
			QString line = file.readLine();
			QString copy = line;
			line.truncate(line.lastIndexOf("\""));
			line.remove(0, line.indexOf("\"")+1);
			copy.truncate(copy.indexOf("="));
			copy.remove(0, copy.indexOf("P_")+2);
			if (copy == "Name") name=line;
			else if (copy == "Level") level=line.toInt();
			else if (copy == "WymProba") proba=line.toFloat();
			else if (copy == "Creatures") possibleCreatures = line;
			else if (copy == "Def") def=line;
		}
		file.close();
	}
	// we have the data, let's parse it :

	while (def != "")
	{
		parseStringAndProcess(def.left(12));
		def.remove(0, 12);
		if (def != "") def.remove(0,1);
	}
	mapLoaded = true;
	hasBeenModifiedSinceLastSave = false;
	mapLevel = level;
	wymProbability = proba;
	possibleWyms = possibleCreatures;

	return name;
}


void MyCanvas::parseStringAndProcess(QString val)
{
	int j	= val.mid(0,2).toInt();
	int i	= val.mid(2,2).toInt();
	int tex = val.mid(4,3).toInt();
	int type = val.mid(7,1).toInt();
	int actionType = val.mid(8,1).toInt();
	int actionParameter = val.mid(9,3).toInt();


	if (sprites[i][j]) delete sprites[i][j];
	sprites[i][j] = new sf::Sprite();
	sprites[i][j]->SetImage(*(TexturesDatabase::getInstance()->getTextureByIndex(tex)->texture));
	sprites[i][j]->Resize(tileWidth, tileHeight*2);
	sprites[i][j]->SetPosition(tileWidth*j, tileHeight*(i-1));
	spritesTextures[i][j] = TexturesDatabase::getInstance()->getTextureByIndex(tex)->name;
	tilesInfo[i][j].type = type;
	tilesInfo[i][j].actionParameter = actionParameter;
	tilesInfo[i][j].actionType = actionType;

	if (strings[i][j]) delete strings[i][j];
	strings[i][j] = new sf::String();
	strings[i][j]->SetSize(12.f);
	strings[i][j]->SetPosition(tileWidth*j+tileWidth/2, tileHeight*i+tileHeight/5);
	QString result =  QString::number(type) + "\n" + QString::number(actionType) + "\n" + QString::number(actionParameter);
	strings[i][j]->SetText(result.toStdString());
}

void MyCanvas::resizeEvent(QResizeEvent * event)
{
	tileWidth =		(float)(event->size().width())/18.f;
	tileHeight =	(float)(event->size().height())/12.f;

	// resize sprites:
	if (mapLoaded)
	{
		for (int i = 0; i < 12; i++)
			for (int j = 0; j < 18; j++)
			{
			sprites[i][j]->Resize(tileWidth, tileHeight*2);
			sprites[i][j]->SetPosition(tileWidth*j, tileHeight*(i-1));
			tilesInfo[i][j].type = 0;
			tilesInfo[i][j].actionParameter = 0;
			tilesInfo[i][j].actionType = 0;
		}
	}

	myInitialized = false;
	this->showEvent(NULL);
}
void MyCanvas::mousePressEvent(QMouseEvent * event)
{
	if (event->button() == Qt::LeftButton)
	{
		if (!mapLoaded)
			return;
		int x = event->x();
		int y = event->y();
		int tileX = x/tileWidth;
		int tileY = y/tileHeight;
		if (mustEditTileTexture == true)
		{
			sprites[tileY][tileX]->SetImage(*TexturesDatabase::getInstance()->getTexture(currentTexture));
			spritesTextures[tileY][tileX] = currentTexture;
		}
		if (mustEditTileType == true) {
			tilesInfo[tileY][tileX] = currentTileInfo;
			QString result =  QString::number(tilesInfo[tileY][tileX].type) + "\n" + QString::number(tilesInfo[tileY][tileX].actionType) + "\n" + QString::number(tilesInfo[tileY][tileX].actionParameter);
			strings[tileY][tileX]->SetText(result.toStdString());
		}

		isPainting = true;
		hasBeenModifiedSinceLastSave = true;
	}
	else if (event->button() == Qt::RightButton)
	{
		currentContextMenuX = event->x();
		currentContextMenuY = event->y();
		currentContextMenuGlobalX = event->globalX();
		currentContextMenuGlobalY = event->globalY();
	}
}
void MyCanvas::mouseMoveEvent(QMouseEvent * event)
{
	if (!mapLoaded)
		return;
	if (isPainting)
	{
		int x = event->x();
		int y = event->y();
		int tileX = x/tileWidth;
		int tileY = y/tileHeight;
		if (tileX < 18 && tileY < 12 && tileX >= 0 && tileY >= 0) {
			if (mustEditTileTexture == true) {
				sprites[tileY][tileX]->SetImage(*TexturesDatabase::getInstance()->getTexture(currentTexture));
				spritesTextures[tileY][tileX] = currentTexture;
			}
			if (mustEditTileType == true) {
				tilesInfo[tileY][tileX] = currentTileInfo;
				QString result =  QString::number(tilesInfo[tileY][tileX].type) + "\n" + QString::number(tilesInfo[tileY][tileX].actionType) + "\n" + QString::number(tilesInfo[tileY][tileX].actionParameter);
				strings[tileY][tileX]->SetText(result.toStdString());
			}
		}
	}
}
void MyCanvas::mouseReleaseEvent(QMouseEvent * event)
{
	isPainting = false;
	event->accept();
}
void MyCanvas::contextMenuEvent(QContextMenuEvent *event)
{
	// get the tile concerned by the click :
	if (!mapLoaded)
		return;
	int x = event->x();
	int y = event->y();
	int tileX = x/tileWidth;
	int tileY = y/tileHeight;
	currentTileX = tileX;
	currentTileY = tileY;

	/* create the related menu */
	QMenu* menu = new QMenu(this);
	QAction* act = NULL;
	act = menu->addAction("Tile Type");
	act->setEnabled(false);
	menu->addSeparator();
	act = menu->addAction("Walkable");
	act->setCheckable(true);
	if (tilesInfo[tileY][tileX].type == 0)
		act->setChecked(true);
	QObject::connect(act, SIGNAL(triggered()), this, SLOT(currentTileIsWalkable()));
	act = menu->addAction("Block");
	act->setCheckable(true);
	if (tilesInfo[tileY][tileX].type == 1)
		act->setChecked(true);
	QObject::connect(act, SIGNAL(triggered()), this, SLOT(currentTileIsBlock()));
	menu->addSeparator();

	act = menu->addAction("Action");
	act->setEnabled(false);
	menu->addSeparator();

	act = menu->addAction("Change Map");
	act->setCheckable(true);
	if (tilesInfo[tileY][tileX].actionType == 1)
		act->setChecked(true);
	if (act->isChecked())
		QObject::connect(act, SIGNAL(triggered()), this, SLOT(currentTileActivatesNothing()));
	else
		QObject::connect(act, SIGNAL(triggered()), this, SLOT(currentTileActivatesChangeMap()));

	act = menu->addAction("Obtain Item");
	act->setCheckable(true);
	if (tilesInfo[tileY][tileX].actionType == 2)
		act->setChecked(true);
	if (act->isChecked())
		QObject::connect(act, SIGNAL(triggered()), this, SLOT(currentTileActivatesNothing()));
	else
		QObject::connect(act, SIGNAL(triggered()), this, SLOT(currentTileActivatesObtainItem()));

	act = menu->addAction("Start Fight");
	act->setCheckable(true);
	if (tilesInfo[tileY][tileX].actionType == 3)
		act->setChecked(true);
	if (act->isChecked())
		QObject::connect(act, SIGNAL(triggered()), this, SLOT(currentTileActivatesNothing()));
	else
		QObject::connect(act, SIGNAL(triggered()), this, SLOT(currentTileActivatesStartFight()));

	act = menu->addAction("Start Dialog");
	act->setCheckable(true);
	if (tilesInfo[tileY][tileX].actionType == 4)
		act->setChecked(true);
	if (act->isChecked())
		QObject::connect(act, SIGNAL(triggered()), this, SLOT(currentTileActivatesNothing()));
	else
		QObject::connect(act, SIGNAL(triggered()), this, SLOT(currentTileActivatesStartDialog()));

	act = menu->addAction("No Random");
	act->setCheckable(true);
	if (tilesInfo[tileY][tileX].actionType == 5)
		act->setChecked(true);
	if (act->isChecked())
		QObject::connect(act, SIGNAL(triggered()), this, SLOT(currentTileActivatesNothing()));
	else
		QObject::connect(act, SIGNAL(triggered()), this, SLOT(currentTileMightNotBeRandom()));

	menu->addSeparator();

	act = menu->addAction("Action Parameter");
	act->setEnabled(false);
	menu->addSeparator();

	QWidgetAction* wa = new QWidgetAction(this);
	QPushButton* pb = new QPushButton("Ok");
	QSpinBox* sb = new QSpinBox();
	sb->setRange(0, 999);
	sb->setValue(tilesInfo[tileY][tileX].actionParameter);
	contextMenuActionParameter = sb;
	QWidget* container = new QWidget();
	QHBoxLayout* layout = new QHBoxLayout();
	layout->addWidget(sb);
	layout->addWidget(pb);
	container->setLayout(layout);
	wa->setDefaultWidget(container);
	menu->addAction(wa);
	QObject::connect(pb, SIGNAL(released()), this, SLOT(currentTileChangeActionParameter()));
	//act = menu.addAction("Select");

	contextMenu = menu;
	menu->exec(event->globalPos());
}

void MyCanvas::OnInit()
{

}

void MyCanvas::OnUpdate()
{
	if (!mapLoaded)
		return;
	for (int i = 0; i < 12; i++)
		for (int j = 0; j < 18; j++)
			Draw(*sprites[i][j]);
	if (showStrings) {
		for (int i = 0; i < 12; i++)
			for (int j = 0; j < 18; j++)
				Draw(*strings[i][j]);
	}
}

void MyCanvas::relaunchContextMenu()
{
	QString result =  QString::number(tilesInfo[currentTileY][currentTileX].type) + "\n" +
					  QString::number(tilesInfo[currentTileY][currentTileX].actionType) + "\n" +
					  QString::number(tilesInfo[currentTileY][currentTileX].actionParameter);
	strings[currentTileY][currentTileX]->SetText(result.toStdString());
	QContextMenuEvent *event = new QContextMenuEvent(QContextMenuEvent::Mouse, QPoint(currentContextMenuX, currentContextMenuY),
													 QPoint(currentContextMenuGlobalX, currentContextMenuGlobalY));
	this->contextMenuEvent(event);

}

void MyCanvas::currentTileIsWalkable()
{
	tilesInfo[currentTileY][currentTileX].type = 0;
	relaunchContextMenu();
}

void MyCanvas::currentTileIsBlock()
{
	tilesInfo[currentTileY][currentTileX].type = 1;
	relaunchContextMenu();
}
void MyCanvas::setMapLevel(int level)
{
	this->mapLevel = level;
}
void MyCanvas::setWymProbability(double probability)
{
	this->wymProbability= probability;
}
void MyCanvas::setShowStrings(bool show)
{
	this->showStrings = show;
}
int MyCanvas::getMapLevel() {
	return this->mapLevel;
}
float MyCanvas::getWymProbability() {
	return this->wymProbability;
}
void MyCanvas::setPossibleWyms(QString wyms) {
	this->possibleWyms = wyms;
}

QString MyCanvas::getPossibleWyms() {
	return this->possibleWyms;
}

void MyCanvas::currentTileActivatesNothing()
{
	tilesInfo[currentTileY][currentTileX].actionType = 0;
	relaunchContextMenu();
}
void MyCanvas::currentTileActivatesChangeMap()
{
	tilesInfo[currentTileY][currentTileX].actionType = 1;
	relaunchContextMenu();
}
void MyCanvas::currentTileActivatesObtainItem()
{
	tilesInfo[currentTileY][currentTileX].actionType = 2;
	relaunchContextMenu();
}
void MyCanvas::currentTileActivatesStartFight()
{
	tilesInfo[currentTileY][currentTileX].actionType = 3;
	relaunchContextMenu();
}
void MyCanvas::currentTileActivatesStartDialog()
{
	tilesInfo[currentTileY][currentTileX].actionType = 4;
	relaunchContextMenu();
}
void MyCanvas::currentTileMightNotBeRandom()
{
	tilesInfo[currentTileY][currentTileX].actionType = 5;
	relaunchContextMenu();
}
void MyCanvas::currentTileChangeActionParameter()
{
	tilesInfo[currentTileY][currentTileX].actionParameter = contextMenuActionParameter->value();
	contextMenu->close();
	relaunchContextMenu();
}












