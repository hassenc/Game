#ifndef MYSFMLCANVAS_H
#define MYSFMLCANVAS_H

#include "QSFMLCanvas.h"
#include <vector>
#include <QResizeEvent>
#include <QMessageBox>
#include <QPushButton>
#include <QFile>
#include <QMenu>
#include <QWidgetAction>
#include <QSpinBox>
#include <QWidget>
#include <QHBoxLayout>
#include "TexturesDatabase.h"

struct TileInfo
{
	int type; // 0=walkable / 1=block
	int actionType; // 0=None / 1=ChangeMap / 2=GiveObject / 3=StartFight / 4=StartDialog
	int actionParameter;
};

class MyCanvas : public QSFMLCanvas
{
	Q_OBJECT;
public :

	MyCanvas(QWidget* Parent, const QPoint& Position, const QSize& Size) ;

	void loadEmptyMap();
	void saveMap(QString filename, QString mapName);
	QString loadMap(QString filename); // returns the name of the map (not its filename)

	void setCurrentTexture(QString tex);
	void setCurrentTileType(int value);
	void setCurrentTileAction(int value);
	void setCurrentTileActionParameter(int value);
	void editTileType(bool edit);
	void editTileTexture(bool edit);

	bool hasBeenModifiedSinceLastSave;
	int getMapLevel();
	float getWymProbability();
	QString getPossibleWyms();

public slots:
	void setMapLevel(int level);
	void setShowStrings(bool show);
	void setWymProbability(double probability);
	void setPossibleWyms(QString wyms);

private :
	QString getTileRelatedString(int x, int y);
	void parseStringAndProcess(QString val);

	virtual void resizeEvent(QResizeEvent *event);
	virtual void mousePressEvent(QMouseEvent *event);
	virtual void mouseMoveEvent(QMouseEvent *event);
	virtual void mouseReleaseEvent(QMouseEvent *event);
	virtual void contextMenuEvent(QContextMenuEvent *event);
	
	void OnInit();
	void OnUpdate();

	void relaunchContextMenu();

private slots:
	void currentTileIsWalkable();
	void currentTileIsBlock();
	void currentTileActivatesNothing();
	void currentTileActivatesChangeMap();
	void currentTileActivatesObtainItem();
	void currentTileActivatesStartFight();
	void currentTileActivatesStartDialog();
	void currentTileMightNotBeRandom();
	void currentTileChangeActionParameter();

private:

	QString spritesTextures[12][18];
	sf::Sprite* sprites[12][18];
	sf::String* strings[12][18];
	TileInfo tilesInfo[12][18];
	int mapLevel;
	float wymProbability;
	QString possibleWyms;
	bool showStrings;
	bool mapLoaded;
	bool isPainting;
	float tileWidth, tileHeight;

	bool mustEditTileType, mustEditTileTexture;
	int currentContextMenuX, currentContextMenuY;
	int currentContextMenuGlobalX, currentContextMenuGlobalY;
	int currentTileX, currentTileY;
	QString currentTexture;
	TileInfo currentTileInfo;

	QSpinBox* contextMenuActionParameter;
	QMenu* contextMenu;
};

#endif // MYSFMLCANVAS_H
