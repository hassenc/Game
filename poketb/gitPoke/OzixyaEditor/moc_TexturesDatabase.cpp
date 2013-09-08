/****************************************************************************
** Meta object code from reading C++ file 'TexturesDatabase.h'
**
** Created: Sun Dec 30 17:02:12 2012
**      by: The Qt Meta Object Compiler version 62 (Qt 4.6.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "TexturesDatabase.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'TexturesDatabase.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.6.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_TexturesDatabase[] = {

 // content:
       4,       // revision
       0,       // classname
       0,    0, // classinfo
       1,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      25,   18,   17,   17, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_TexturesDatabase[] = {
    "TexturesDatabase\0\0smooth\0setSmoothAll(bool)\0"
};

const QMetaObject TexturesDatabase::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_TexturesDatabase,
      qt_meta_data_TexturesDatabase, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &TexturesDatabase::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *TexturesDatabase::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *TexturesDatabase::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_TexturesDatabase))
        return static_cast<void*>(const_cast< TexturesDatabase*>(this));
    if (!strcmp(_clname, "Singleton<TexturesDatabase>"))
        return static_cast< Singleton<TexturesDatabase>*>(const_cast< TexturesDatabase*>(this));
    return QObject::qt_metacast(_clname);
}

int TexturesDatabase::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: setSmoothAll((*reinterpret_cast< bool(*)>(_a[1]))); break;
        default: ;
        }
        _id -= 1;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
