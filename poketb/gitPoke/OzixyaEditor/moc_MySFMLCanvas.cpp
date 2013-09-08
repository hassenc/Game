/****************************************************************************
** Meta object code from reading C++ file 'MySFMLCanvas.h'
**
** Created: Sun Dec 30 17:02:11 2012
**      by: The Qt Meta Object Compiler version 62 (Qt 4.6.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "MySFMLCanvas.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'MySFMLCanvas.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.6.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_MyCanvas[] = {

 // content:
       4,       // revision
       0,       // classname
       0,    0, // classinfo
      13,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      16,   10,    9,    9, 0x0a,
      38,   33,    9,    9, 0x0a,
      71,   59,    9,    9, 0x0a,
     102,   97,    9,    9, 0x0a,
     127,    9,    9,    9, 0x08,
     151,    9,    9,    9, 0x08,
     172,    9,    9,    9, 0x08,
     202,    9,    9,    9, 0x08,
     234,    9,    9,    9, 0x08,
     267,    9,    9,    9, 0x08,
     300,    9,    9,    9, 0x08,
     334,    9,    9,    9, 0x08,
     364,    9,    9,    9, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_MyCanvas[] = {
    "MyCanvas\0\0level\0setMapLevel(int)\0show\0"
    "setShowStrings(bool)\0probability\0"
    "setWymProbability(double)\0wyms\0"
    "setPossibleWyms(QString)\0"
    "currentTileIsWalkable()\0currentTileIsBlock()\0"
    "currentTileActivatesNothing()\0"
    "currentTileActivatesChangeMap()\0"
    "currentTileActivatesObtainItem()\0"
    "currentTileActivatesStartFight()\0"
    "currentTileActivatesStartDialog()\0"
    "currentTileMightNotBeRandom()\0"
    "currentTileChangeActionParameter()\0"
};

const QMetaObject MyCanvas::staticMetaObject = {
    { &QSFMLCanvas::staticMetaObject, qt_meta_stringdata_MyCanvas,
      qt_meta_data_MyCanvas, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &MyCanvas::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *MyCanvas::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *MyCanvas::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_MyCanvas))
        return static_cast<void*>(const_cast< MyCanvas*>(this));
    return QSFMLCanvas::qt_metacast(_clname);
}

int MyCanvas::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QSFMLCanvas::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: setMapLevel((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 1: setShowStrings((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 2: setWymProbability((*reinterpret_cast< double(*)>(_a[1]))); break;
        case 3: setPossibleWyms((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 4: currentTileIsWalkable(); break;
        case 5: currentTileIsBlock(); break;
        case 6: currentTileActivatesNothing(); break;
        case 7: currentTileActivatesChangeMap(); break;
        case 8: currentTileActivatesObtainItem(); break;
        case 9: currentTileActivatesStartFight(); break;
        case 10: currentTileActivatesStartDialog(); break;
        case 11: currentTileMightNotBeRandom(); break;
        case 12: currentTileChangeActionParameter(); break;
        default: ;
        }
        _id -= 13;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
