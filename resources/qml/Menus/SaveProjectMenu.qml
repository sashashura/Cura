// Copyright (c) 2021 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 1.1

import UM 1.6 as UM
import Cura 1.1 as Cura

import "../Dialogs"

Menu
{
    id: saveProjectMenu
    title: catalog.i18nc("@title:menu menubar:file", "Save project...")
    property alias model: projectOutputDevices.model

    Instantiator
    {
        id: projectOutputDevices
        MenuItem
        {
            text: model.name
            onTriggered:
            {
                var args = { "filter_by_machine": false, "file_type": "workspace", "preferred_mimetypes": "application/vnd.ms-package.3dmanufacturing-3dmodel+xml" };
                if (UM.Preferences.getValue("cura/dialog_on_project_save"))
                {
                    saveWorkspaceDialog.deviceId = model.id
                    saveWorkspaceDialog.args = args
                    saveWorkspaceDialog.open()
                }
                else
                {
                    UM.OutputDeviceManager.requestWriteToDevice(model.id, PrintInformation.jobName, args)
                }
            }
            // Unassign the shortcuts when the submenu is invisible (i.e. when there is only one file provider) to avoid ambiguous shortcuts.
            // When there is a signle file provider, the openAction is assigned with the Ctrl+O shortcut instead.
            shortcut: saveProjectMenu.visible ? model.shortcut : ""
        }
        onObjectAdded: saveProjectMenu.insertItem(index, object)
        onObjectRemoved: saveProjectMenu.removeItem(object)
    }

    WorkspaceSummaryDialog
    {
        id: saveWorkspaceDialog
        property var args
        property var deviceId
        onYes: UM.OutputDeviceManager.requestWriteToDevice(deviceId, PrintInformation.jobName, args)
    }
}
