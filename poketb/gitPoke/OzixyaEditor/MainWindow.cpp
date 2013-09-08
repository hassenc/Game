#include "MainWindow.h"
#include "ui_MainWindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
	currentMapFilename = "";
	DirectoryManager* dirMng = DirectoryManager::getInstance();

	SFMLView = new MyCanvas(this, QPoint(20, 20), QSize(360, 360));

	// set a special format input for the creatures
	QRegExp rx("([0-9]+;)*");
	QValidator *validator = new QRegExpValidator(rx, this);

	ui->lineEditAllowedCreatures->setValidator(validator);

	// load a default texture:
	TexturesDatabase::getInstance()->getTexture("empty.png");
	TexturesDatabase::getInstance()->mustSave = false;
    this->setCentralWidget(SFMLView);

	ui->InformationDock->setFixedHeight(290);;

	ui->tableWidget->setColumnCount(10);
	for (int i = 0; i < 10; i++)
		ui->tableWidget->setColumnWidth(i, 31);
	ui->tableWidget->setFixedWidth(31*10+5);

	this->showMaximized();

	/*QFile fileText("../media/maps/textures/textures.otd");
	if (fileText.exists())
	{
		TexturesDatabase::getInstance()->loadDatabase("../media/maps/textures/textures.otd");
		reloadTextures();
	}*/

	QObject::connect(ui->checkBoxShowGrid, SIGNAL(clicked(bool)), TexturesDatabase::getInstance(), SLOT(setSmoothAll(bool)));
	QObject::connect(ui->checkBoxEditTexture, SIGNAL(clicked(bool)), this, SLOT(editTileTexture(bool)));
	QObject::connect(ui->checkBoxEditTileType, SIGNAL(clicked(bool)), this, SLOT(editTileType(bool)));
	QObject::connect(ui->comboBoxActionType, SIGNAL(activated(int)), this, SLOT(changeTileAction(int)));
	QObject::connect(ui->spinBoxActionParameter, SIGNAL(valueChanged(int)), this, SLOT(changeTileActionParameter(int)));
	QObject::connect(ui->comboBoxTileType, SIGNAL(activated(int)), this, SLOT(changeTileType(int)));
	QObject::connect(ui->actionSave, SIGNAL(triggered()), this, SLOT(saveMap()));
	QObject::connect(ui->actionSave_As, SIGNAL(triggered()), this, SLOT(saveMapAs()));
	QObject::connect(ui->actionOpen, SIGNAL(triggered()), this, SLOT(loadMap()));
	QObject::connect(ui->actionNew, SIGNAL(triggered()), this, SLOT(newMap()));
	QObject::connect(ui->actionOpen_Database, SIGNAL(triggered()), this, SLOT(loadTexturesDatabase()));
	QObject::connect(ui->actionSave_Database, SIGNAL(triggered()), this, SLOT(saveTexturesDatabase()));
	QObject::connect(ui->tableWidget, SIGNAL(currentCellChanged(int,int,int,int)), this, SLOT(changeTexture()));
	QObject::connect(ui->actionAddTexturesFolder, SIGNAL(triggered()), this, SLOT(loadTextures()));
	QObject::connect(ui->actionEdit_Dialogs, SIGNAL(triggered()), this, SLOT(openDialogWindow()));
	QObject::connect(ui->showTextCheckBox, SIGNAL(clicked(bool)), this->SFMLView, SLOT(setShowStrings(bool)));
	QObject::connect(ui->levelSpinBox, SIGNAL(valueChanged(int)), this->SFMLView, SLOT(setMapLevel(int)));
	QObject::connect(ui->lineEditAllowedCreatures, SIGNAL(textChanged(QString)), this->SFMLView, SLOT(setPossibleWyms(QString)));
	QObject::connect(ui->doubleSpinBoxWymProbability, SIGNAL(valueChanged(double)), this->SFMLView, SLOT(setWymProbability(double)));
	QObject::connect(ui->actionQuit, SIGNAL(triggered()), this, SLOT(close()));
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::changeEvent(QEvent *e)
{
    QMainWindow::changeEvent(e);
    switch (e->type()) {
    case QEvent::LanguageChange:
        ui->retranslateUi(this);
        break;
    default:
        break;
    }
}

void MainWindow::newMap()
{
	SFMLView->loadEmptyMap();
}

void MainWindow::loadTextures()
{
	QString dirName = QFileDialog::getExistingDirectory(  0, "Map Textures Directory Selection", "", QFileDialog::ShowDirsOnly );

	QDir dir(dirName);
	QStringList filters;
	filters << "*.png" << "*.jpg" << "*.bmp" << "*.jpeg";
	QStringList list = dir.entryList( filters, QDir::NoFilter, QDir::NoSort );
	ui->tableWidget->setRowCount((list.size()+9)/10);
	QDir dir2 = QDir::current().absolutePath(); // this is the working directory of the editor
	for (int i = 0; i < list.size(); i++)
	{
		QString pathToFile = dir2.relativeFilePath(dir.absolutePath()+"/"+list.at(i));
		pathToFile.remove(0, pathToFile.lastIndexOf("media/maps"));
		TexturesDatabase::getInstance()->getTexture(pathToFile);
		//QMessageBox::information(0, "add", dir.relativeFilePath(dir.absolutePath()+"/"+list.at(i)));
	}
	reloadTextures();
}

void MainWindow::reloadTextures()
{
	const std::vector<Texture>* textures = TexturesDatabase::getInstance()->getTextures();
	ui->tableWidget->setRowCount((textures->size()+9)/10);
	for (unsigned int i = 0; i < textures->size(); i++)
	{
		int posX = i%10;
		int posY = i/10;
		ui->tableWidget->setItem(posY,posX, new QTableWidgetItem(QIcon(textures->at(i).name), textures->at(i).name));
		ui->tableWidget->setRowHeight(posY, 62);
	}
}

void MainWindow::changeTexture()
{
	if (!ui->tableWidget->currentItem())
		return;
	QString texName = ui->tableWidget->currentItem()->text();
	SFMLView->setCurrentTexture(texName);
}
void MainWindow::changeTileType(int val)
{
	SFMLView->setCurrentTileType(val);
}
void MainWindow::changeTileAction(int val)
{
	SFMLView->setCurrentTileAction(val);
}
void MainWindow::changeTileActionParameter(int val)
{
	SFMLView->setCurrentTileActionParameter(val);
}
void MainWindow::editTileType(bool val)
{
	SFMLView->editTileType(val);
}
void MainWindow::editTileTexture(bool val)
{
	SFMLView->editTileTexture(val);
}

void MainWindow::closeEvent(QCloseEvent *event)
{
	if (TexturesDatabase::getInstance()->mustSave)
	{
		int answer = QMessageBox::warning(this, "Textures database modified", "The textures database has changed but has not been saved. It is adviced to save it. Do you want to save it now ?", QMessageBox::Yes | QMessageBox::No | QMessageBox::Cancel);
		if (answer == QMessageBox::Yes)
		{
			saveTexturesDatabase();
		}
		else if (answer == QMessageBox::Cancel)
		{
			event->ignore();
			return;
		}
	}
	if (SFMLView->hasBeenModifiedSinceLastSave)
	{
		int answer = QMessageBox::warning(this, "Changes Unsaved", "Warning, <strong>some map modifications has not been saved</strong>.\nDo you want to save them now ?", QMessageBox::Yes | QMessageBox::No | QMessageBox::Cancel);
		if (answer == QMessageBox::Yes)
		{
			saveMap();
		}
		else if (answer == QMessageBox::Cancel)
		{
			event->ignore();
			return;
		}
		else if (answer == QMessageBox::No)
				event->accept();

	}
}

void MainWindow::loadMap()
{
	if (TexturesDatabase::getInstance()->hasLoaded == false)
	{
		int answer = QMessageBox::information(this, "No Textures Loaded", "You did not load any texture database. The map will be shown as empty. Do you want to open a textures database before loading the map ?", QMessageBox::Yes | QMessageBox::No);
		if (answer == QMessageBox::Yes)
		{
			loadTexturesDatabase();
		}
	}
	QString filename = QFileDialog::getOpenFileName(this, "Open Map", "../media/maps/", "Ozixya Maps (*.om)");
	if (filename != "")
	{
		QString name = SFMLView->loadMap(filename);
		ui->lineEditMapName->setText(name);
		if (name != "") // we loaded successfully an existing map
			currentMapFilename = filename;
		ui->levelSpinBox->setValue(SFMLView->getMapLevel());
		ui->doubleSpinBoxWymProbability->setValue(SFMLView->getWymProbability());;
		ui->lineEditAllowedCreatures->setText(SFMLView->getPossibleWyms());
	}
}

void MainWindow::saveMap()
{
	if (TexturesDatabase::getInstance()->mustSave)
	{
		int answer = QMessageBox::warning(this, "Textures database modified", "It is recommended to save the textures database before saving any map. Do you want to save it now ?", QMessageBox::Yes | QMessageBox::No | QMessageBox::Cancel);
		if (answer == QMessageBox::Yes)
		{
			QString filename = QFileDialog::getSaveFileName(this, "Save Texture Database", "../media/maps/textures/textures.otd", "Ozixya Texture Database (*.otd)");
			if (filename != "")
				TexturesDatabase::getInstance()->saveDatabase(filename);
		}
		else if (answer == QMessageBox::Cancel)
				return;
	}
	QString filename = "";
	if (currentMapFilename != "")
		filename = QFileDialog::getSaveFileName(this, "Save Map", currentMapFilename, "Ozixya Maps (*.om)");
	else
		filename = QFileDialog::getSaveFileName(this, "Save Map", "../media/maps", "Ozixya Maps (*.om)");
	if (filename != "")
		SFMLView->saveMap(filename, ui->lineEditMapName->text());
}
void MainWindow::saveMapAs()
{
	if (TexturesDatabase::getInstance()->mustSave)
	{
		int answer = QMessageBox::warning(this, "Textures database modified", "It is recommended to save the textures database before saving any map. Do you want to save it now ?", QMessageBox::Yes | QMessageBox::No | QMessageBox::Cancel);
		if (answer == QMessageBox::Yes)
		{
			QString filename = QFileDialog::getSaveFileName(this, "Save Texture Database", "../media/maps/textures/textures.otd", "Ozixya Texture Database (*.otd)");
			if (filename != "")
				TexturesDatabase::getInstance()->saveDatabase(filename);
		}
		else if (answer == QMessageBox::Cancel)
				return;
	}
	QString filename = QFileDialog::getSaveFileName(this, "Save Map", "../media/maps", "Ozixya Maps (*.om)");
	if (filename != "")
		SFMLView->saveMap(filename, ui->lineEditMapName->text());
}

void MainWindow::loadTexturesDatabase()
{
	QString filename = QFileDialog::getOpenFileName(this, "Open Texture Database", "../media/maps/textures/textures.otd", "Ozixya Texture Database (*.otd)");
	if (filename == "") return;
	TexturesDatabase::getInstance()->loadDatabase(filename);
	reloadTextures();

}
void MainWindow::saveTexturesDatabase()
{
	QString filename = QFileDialog::getSaveFileName(this, "Save Texture Database", "../media/maps/textures/textures.odt", "Ozixya Texture Database (*.otd)");
	if (filename != "")
		TexturesDatabase::getInstance()->saveDatabase(filename);

}

void MainWindow::openDialogWindow()
{
	dialogEditor = new DialogEditor();
	dialogEditor->show();
}




