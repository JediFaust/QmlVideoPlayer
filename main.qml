import QtQuick
import QtMultimedia
import QtQuick.Dialogs
import NativeConnector 1.0

Window {
    id: mainWindow
    visible: true
    width: Screen.width
    height: Screen.height
    title: qsTr("Omur QML Test")
    property bool isPlaying: player.playbackState === MediaPlayer.PlayingState


    NativeConnector {
        id: lockPreventer
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a videofile"

        onAccepted: {
            console.log("You choose: " + fileDialog.selectedFile)
            player.source = fileDialog.selectedFile
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    Item {
        id: mainItem
        anchors.fill: parent
        MediaPlayer {
            id: player
            source: "qrc:/assets/jeruto.mp4"
            videoOutput: videoOut
            audioOutput: audioOut
            onSourceChanged: player.play()
            onPlaybackStateChanged: (state) => {
                                        lockPreventer.switchLock(state === MediaPlayer.PlayingState)
                                    }
        }

        VideoOutput {
            id: videoOut
            anchors.fill: parent
            focus: true

            transform: [ Scale { id: videoScale }, Translate { id: videoTranslate } ]

            Item {
                id: panner
                width: 1
                height: 1
                onXChanged: videoTranslate.x = panner.x
                onYChanged: videoTranslate.y = panner.y
            }

            MouseArea {
                anchors.fill: parent
                drag.axis: Drag.XAndYAxis
                drag.target: panner
                drag.minimumX: -(videoScale.xScale - 1) * parent.width / 2
                drag.maximumX: (videoScale.xScale - 1) * parent.width / 2
                drag.minimumY: -(videoScale.yScale - 1) * parent.height / 2
                drag.maximumY: (videoScale.yScale - 1) * parent.height / 2
            }

            PinchArea {
                anchors.fill: parent
                onPinchUpdated: (pinch) => {
                                    videoScale.origin.x = parent.width / 2
                                    videoScale.origin.y = parent.height / 2

                                    // Pinch to Zoom
                                    if (pinch.scale > pinch.previousScale) {
                                        if(videoScale.xScale < 4) {
                                            videoScale.xScale /= 0.95
                                            videoScale.yScale /= 0.95
                                        }
                                    } else {
                                        if (videoScale.xScale > 1) {
                                            videoScale.xScale *= 0.95
                                            videoScale.yScale *= 0.95
                                        }
                                    }

                                    // Pinch move to pan
                                    videoTranslate.x += pinch.center.x - pinch.previousCenter.x
                                    videoTranslate.y += pinch.center.y - pinch.previousCenter.y
                                }
            }

            Keys.onSpacePressed: isPlaying ? player.pause() : player.play()
            Keys.onLeftPressed: player.position -= 5000
            Keys.onRightPressed: player.position += 5000
        }

        AudioOutput {
            id: audioOut
        }

        Item {
            id: toolbar
            anchors.bottom: parent.bottom
            width: parent.width
            height: parent.height / 12

            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.4
            }

            Image {
                source: isPlaying ? "qrc:/assets/pause.png" : "qrc:/assets/play-buttton.png"
                sourceSize.width: 40
                sourceSize.height: 40
                anchors.centerIn: toolbar

                MouseArea {
                    id: toolbarArea
                    anchors.fill: parent

                    onClicked: {
                        isPlaying ? player.pause() : player.play()
                    }
                }
            }

            Image {
                source: "qrc:/assets/download.png"
                sourceSize.width: 40
                sourceSize.height: 40
                anchors.left: toolbar.left
                anchors.leftMargin: parent.width / 8
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        console.log("Loading file...")
                        fileDialog.open()
                    }
                }
            }

            Item {
                id: scrollbar
                width: parent.width
                height: 6
                anchors.bottom: toolbar.top

                Rectangle {
                    anchors.fill: parent
                    opacity: 0.5
                }

                Rectangle {
                    height: parent.height
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: dragger.left
                    color: "red"
                }

                Rectangle {
                    property bool isDragging: false
                    id: dragger
                    width: 20
                    height: 20
                    radius: 20
                    anchors.verticalCenter: scrollbar.verticalCenter
                    x: dragger.isDragging
                        ? draggerArea.mouseX
                        : parent.width * (player.position / player.duration)
                    visible: draggerArea.containsMouse || dragger.isDragging ? true : false
                    color: "red"
                    onXChanged: if (isDragging)
                                    player.position = player.duration * (draggerArea.mouseX / parent.width)
                }

                MouseArea {
                    id: draggerArea
                    anchors.fill: parent
                    drag.axis: Drag.XAxis
                    drag.target: dragger
                    hoverEnabled: true

                    onPressed: {
                        player.pause()
                        dragger.isDragging = true
                    }
                    onReleased: {
                        player.position = player.duration * (draggerArea.mouseX / parent.width)
                        dragger.isDragging = false
                        player.play()
                    }
                }
            }
        }
    }
}
