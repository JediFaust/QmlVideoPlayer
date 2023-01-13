#ifndef NATIVECONNECTOR_H
#define NATIVECONNECTOR_H

#include <QObject>

class NativeConnector : public QObject
{
    Q_OBJECT
public:
    explicit NativeConnector(QObject *parent = nullptr);

signals:

public slots:
    void switchLock(bool currentLockState);

};

#endif // NATIVECONNECTOR_H
