# Customization and troubleshooting

## Edit names and always-on-top

Select **EDIT** in the widget to change either button's displayed name or its always-on-top preference. These preferences are saved locally.

Fresh settings use **ChatGPT** for the blue button and **Codex** for the purple button. Existing saved names are kept when upgrading; use **EDIT** to change them if desired.

Changing a name does not change the button's action. The blue button still sends **Alt+3**, and the purple button still sends **Alt+1**.

Move the widget using its title area and resize it from the lower-right corner. Its saved position and size are restored on later runs.

## Settings location

```text
%APPDATA%\NeonChatSelector\settings-v0.3.json
```

The launcher uses the original v0.3 settings location, so an existing installation's v0.3 preferences are reused. The branding update on 2026-10-08 preserves this behavior. The release ZIP contains no personal settings.

## Reset settings

If the widget opens off-screen after changing displays, or you want the default labels and preferences:

1. Close the widget.
2. Open `%APPDATA%\NeonChatSelector` in File Explorer.
3. Rename `settings-v0.3.json` to keep a backup, or delete that file.
4. Start the widget again.

Remove only the v0.3 settings file. Other files in this folder may belong to earlier selector versions.

## If a button does not switch modes

Make sure the ChatGPT Windows desktop app is open and signed in. This widget does not start the app or control a standalone Codex application.

Check what **Alt+3** and **Alt+1** do when you press them directly inside your ChatGPT app. Their meaning can differ between app versions or configurations. The widget's card highlight records a request, so a changed highlight is not proof that the app switched.

Detection expects the process name `ChatGPT` and a window title containing `ChatGPT` or `Codex`. If an app update changes those details, source changes may be needed.

Foreground focus can also be interrupted. Keep the ChatGPT window available and avoid typing while the widget sends its shortcut.

## If the widget does not open

Confirm that you extracted the ZIP and started `Start-Launcher.cmd` from the extracted folder. Windows PowerShell 5.1, .NET Framework/WPF, and `WScript.Shell` must be available.

To see error messages, open a PowerShell console in the extracted folder and run:

```powershell
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File .\src\ChatGPT-Codex-Selector-v0.3.ps1
```

This applies the execution-policy override only to that PowerShell process. It does not permanently change Windows policy. If your organization blocks scripts or Windows Script Host, follow its IT guidance; do not bypass its controls.

## Source-level customization

All interface visuals are embedded in the PowerShell source as XAML. No separate visual assets are needed at runtime.

For changes beyond the edit panel, make a copy of the source first and edit `src/ChatGPT-Codex-Selector-v0.3.ps1`. The keyboard shortcuts are fixed in that file. Test any changed mapping directly in your app, then test it through the widget before relying on it.

A customized copy has not received the original build's live testing. Keep the downloaded release available so you can return to the accepted behavior.
