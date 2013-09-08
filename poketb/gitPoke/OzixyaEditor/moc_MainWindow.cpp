/****************************************************************************
** Meta object code from reading C++ file 'MainWindow.h'
**
** Created: Sun Dec 30 17:02:10 2012
**      by: The Qt Meta Object Compiler version 62 (Qt 4.6.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "MainWindow.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'MainWindow.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.6.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_MainWindow[] = {

 // content:
       4,       // revision
       0,       // classname
       0,    0, // classinfo
      15,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      12,   11,   11,   11, 0x0a,
      27,   11,   11,   11, 0x0a,
      44,   11,   11,   11, 0x0a,
      60,   11,   11,   11, 0x0a,
      80,   11,   11,   11, 0x0a,
     102,   11,   11,   11, 0x0a,
     133,   11,   11,   11, 0x0a,
     152,   11,   11,   11, 0x0a,
     174,   11,   11,   11, 0x0a,
     183,   11,   11,   11, 0x0a,
     193,   11,   11,   11, 0x0a,
     203,   11,   11,   11, 0x0a,
     215,   11,   11,   11, 0x0a,
     238,   11,   11,   11, 0x0a,
     261,   11,   11,   11, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_MainWindow[] = {
    "MainWindow\0\0loadTextures()\0reloadTextures()\0"
    "changeTexture()\0changeTileType(int)\0"
    "changeTileAction(int)\0"
    "changeTileActionParameter(int)\0"
    "editTileType(bool)\0editTileTexture(bool)\0"
    "newMap()\0loadMap()\0saveMap()\0saveMapAs()\0"
    "loadTexturesDatabase()\0saveTexturesDatabase()\0"
    "openDialogWindow()\0"
};

const QMetaObject MainWindow::staticMetaObject = {
    { &QMainWindow::staticMetaObject, qt_meta_stringdata_MainWindow,
      qt_meta_data_MainWindow, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &MainWindow::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *MainWindow::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *MainWindow::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_MainWindow))
        return static_cast<void*>(const_cast< MainWindow*>(this));
    return QMainWindow::qt_metacast(_clname);
}

int MainWindow::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: loadTextures(); break;
        case 1: reloadTextures(); break;
        case 2: changeTexture(); break;
        case 3: changeTileType((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 4: changeTileAction((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 5: changeTileActionParameter((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 6: editTileType((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 7: editTileTexture((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 8: newMap(); break;
        case 9: loadMap(); break;
        case 10: saveMap(); break;
        case 11: saveMapAs(); break;
        case 12: loadTexturesDatabase(); break;
        case 13: saveTexturesDatabase(); break;
        case 14: openDialogWindow(); break;
        default: ;
        }
        _id -= 15;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
