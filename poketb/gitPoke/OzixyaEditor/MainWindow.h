#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QFileDialog>
#include "MySFMLCanvas.h"
#include "DialogEditor.h"
#include "DirectoryManager.h"

namespace Ui {
    class MainWindow;
}

class MainWindow : public QMainWindow {
    Q_OBJECT
public:
	MainWindow(QWidget *parent = 0);
    ~MainWindow();

public slots:
	void loadTextures();
	void reloadTextures();
	void changeTexture();
	void changeTileType(int);
	void changeTileAction(int);
	void changeTileActionParameter(int);
	void editTileType(bool);
	void editTileTexture(bool);
	void newMap();
	void loadMap();
	void saveMap();
	void saveMapAs();
	void loadTexturesDatabase();
	void saveTexturesDatabase();
	void openDialogWindow();


protected:
	void changeEvent(QEvent *);
	virtual void closeEvent(QCloseEvent *);

private:
    Ui::MainWindow *ui;
	MyCanvas* SFMLView;
	DialogEditor* dialogEditor;
	QString currentMapFilename;
};

#endif // MAINWINDOW_H
