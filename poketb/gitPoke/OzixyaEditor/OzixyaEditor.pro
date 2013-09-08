# -------------------------------------------------
# Project created by QtCreator 2012-10-30T23:30:32
# -------------------------------------------------
QT += opengl
TARGET = OzixyaEditorV1
TEMPLATE = app
SOURCES += main.cpp \
    MainWindow.cpp \
    QSFMLCanvas.cpp \
    TexturesDatabase.cpp \
    MySFMLCanvas.cpp \
    DialogEditor.cpp \
    DialogDatabase.cpp
HEADERS += MainWindow.h \
    QSFMLCanvas.h \
    MySFMLCanvas.h \
    TexturesDatabase.h \
    Singleton.h \
    DialogEditor.h \
    DialogDatabase.h
FORMS += MainWindow.ui \
    DialogEditor.ui
LIBS += -lsfml-system \
    -lsfml-window \
    -lsfml-graphics \
    -lsfml-audio
