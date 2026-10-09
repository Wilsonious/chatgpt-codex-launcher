# Security and privacy

## What the launcher does

The launcher searches for a matching local ChatGPT desktop window, brings it to the foreground, and sends a fixed keyboard shortcut using Windows Script Host. It also saves widget preferences in your local roaming application-data folder.

It does not make network requests, collect telemetry, read conversations, access an API key, or send chat content anywhere. The ChatGPT app's own network and privacy behavior is separate.

## Review before running

The release contains readable PowerShell source and a small Windows launch helper. Both are unsigned. Review them before trusting a download.

If Windows marks the downloaded ZIP as blocked, you can review the source first and then use **Unblock** in the ZIP's Properties window, if that option is present. Extract the ZIP before running the launcher.

The release includes SHA-256 checksums to help check that downloaded files match the published package. A checksum verifies matching bytes; it does not establish who authored a file or whether it is safe.

## PowerShell launch behavior

`Start-Launcher.cmd` uses Windows PowerShell 5.1 with:

- `-NoProfile` to avoid loading the user's PowerShell profile.
- `-STA` for the WPF interface.
- `-WindowStyle Hidden` to keep the console out of the way.
- `-ExecutionPolicy Bypass` for that process only.

This does not change the saved execution policy in the registry. An organization's Group Policy can still take precedence. See [Microsoft's execution-policy documentation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-5.1).

No administrator rights are required. On a managed device, follow your organization's IT rules if scripts or Windows Script Host are restricted.

## Keyboard focus

The widget sends keyboard input rather than using an app API. Another window can take focus between the focus request and the shortcut. Avoid typing while switching, and confirm the app's mode before continuing your work.

The card highlight shows the last requested mode; it is not a success confirmation or a reading of the app's state.

## Local settings

Preferences are stored in:

```text
%APPDATA%\NeonChatSelector\settings-v0.3.json
```

An existing v0.3 settings file is reused. Personal settings are not distributed in the public package. Close the widget before removing or resetting that file.

If you report a problem, review screenshots and logs for private information before posting them publicly. Do not include chat content, credentials, or personal settings unless you have deliberately removed anything sensitive.
