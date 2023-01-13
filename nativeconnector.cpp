#include <QJniObject>
#include <QDebug>
#include <QGuiApplication>
#include "nativeconnector.h"

NativeConnector::NativeConnector(QObject *parent)
    : QObject{parent}
{
    qDebug() << "C++ worked on constructor";
}

void NativeConnector::switchLock(bool currentLockState) {
//    QJniObject nativeObj = QNativeInterface::QAndroidApplication::context();
    QJniObject nativeObj = QJniObject("com.QtVideoPlayer/PreventLock",
                                 "(Landroid/content/Context;)V",
                                 QNativeInterface::QAndroidApplication::context());


    qDebug() << "C++ started on switchLock";

    nativeObj.callMethod<void>("preventLock", "(Z)V", currentLockState);
//    qDebug() << nativeObj.callMethod<jstring>("sayHello").toString();

    qDebug() << "C++ ended on switchLock";
}
