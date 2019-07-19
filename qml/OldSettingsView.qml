import QtQuick 2.12
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3

Rectangle {
    color: "#09030a"
    property bool d2Maphack: settings.D2Maphack
    property bool hdMaphack: settings.HDMaphack
    
    ColumnLayout {
        anchors.fill: parent
        Column {
            id: fileDialogBox
            width: (root.width/2)
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.topMargin: 50    
            spacing: 5

            Column {
                topPadding: 15

                SText {
                    text: "Set Diablo II directory"
                    font.pixelSize: 13
                    font.bold: true
                }
            }

            Row {
                TextField {
                    id: d2pathInput
                    width: fileDialogBox.width * 0.80
                    readOnly: true
                    text: settings.D2Location

                    background: Rectangle {
                        radius: 3
                        color: "#1d1924"
                    }
                }

                SButton {
                    id: chooseD2Path
                    text: "Open"
                    width: fileDialogBox.width * 0.20
                    onClicked: d2PathDialog.open()
                }
            }

            Column {
                topPadding: 15
                SText {
                    text: "Number of instances"
                }
                
                Dropdown{
                    id: d2Instances
                    height: 30
                    width: 60
                }

                Check{
                    checked: d2Maphack

                    onClicked: {
                        d2Maphack = this.checked
                    }
                }
            }

            Row {
                topPadding: 15
                width: parent.width
                
                layoutDirection: Qt.RightToLeft

                Item {
                    width: parent.width * 0.20
                    height: 35

                    Switch {
                        id: hdEnabled
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        checked: false
                    }
                }

                Item {
                    width: parent.width * 0.80
                    height: 35
                     Layout.alignment: Qt.AlignLeft

                     SText {
                         anchors.verticalCenter: parent.verticalCenter
                         text: "Do you have a HD Diablo II?"
                     }
                }
            }

            Column {
                topPadding: 15
                SText {
                    text: "Set HD directory"
                    font.bold: true
                }

                visible: hdEnabled.checked
            }

            Row {
                TextField {
                    id: hdPathInput
                    width: fileDialogBox.width * 0.80
                    readOnly: true
                    text: settings.HDLocation
                    background: Rectangle {
                        radius: 3; color: "#1d1924"
                    }
                }

                SButton {
                    id: chooseHDPath
                    text: "Open"
                    width: fileDialogBox.width * 0.20
                    onClicked: hdPathDialog.open()
                }

                visible: hdEnabled.checked
            }

            Column {
                visible: hdEnabled.checked
                topPadding: 15

                SText {
                    text: "Number of HD instances"
                }
                
                ComboBox {
                    id: hdInstances
                    model: [ 1, 2, 3, 4 ]
                    height: 30
                    width: 60

                    background: Rectangle {
                        color: "#1d1924"
                        border.color: "#f0681f"
                        radius: height/2
                    }
                }

                Check{
                    checked: hdMaphack
                    onClicked: {
                        hdMaphack = this.checked
                    }
                }
            }

            // Save button.
            Column {
                topPadding: 25

                SButton {
                    id: saveGamePath
                    width: 200
                    height: 40
                    label: "SAVE SETTINGS"

                    onClicked: {
                        var hdPath = hdPathInput.text
                        var hdi = hdInstances.currentText
                        
                        // HD isn't enable, reset the HD fields.
                        if(!hdEnabled.checked) {
                            hdPath = ""
                            hdi = 0
                        }

                        // Update settings in the backend.
                        /*var success = settings.update(
                            d2pathInput.text,
                            d2Instances.currentText,
                            d2Maphack,
                            hdPath,
                            hdi,
                            hdMaphack,
                        )*/

                        /*var game = {
                            "location": "derp",
                            "instances": 1,
                            "maphack": true,
                            "hd": true
                        }*/

                        var success = settings.updateNew("DERP")

                        if (success) {
                            settingsDialog.visible = false
                            diablo.validateVersion()
                        }
                    }
                }
            }
        }   
        
        // File dialogs.
        FileDialog {
            id: d2PathDialog
            selectFolder: true
            folder: shortcuts.home
            
            onAccepted: {
                var path = d2PathDialog.fileUrl.toString()
                path = path.replace(/^(file:\/{2})/,"")
                d2pathInput.text = path
            }
        }

        FileDialog {
            id: hdPathDialog
            selectFolder: true
            folder: shortcuts.home

            onAccepted: {
                var path = hdPathDialog.fileUrl.toString()
                path = path.replace(/^(file:\/{2})/,"")
                hdPathInput.text = path
            }
        }
    }
}