#include <QJniObject>
#include <QDebug>
#include <QGuiApplication>
#include "nativeconnector.h"

NativeConnector::NativeConnector(QObject *parent)
    : QObject{parent}
{

}

void NativeConnector::switchLock(bool currentLockState) {
    QJniObject nativeObj = QNativeInterface::QAndroidApplication::context();

    nativeObj.callMethod<void>("preventLock", "(Z)V", currentLockState);
}
