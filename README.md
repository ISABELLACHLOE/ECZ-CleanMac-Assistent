
# CleanMac Assistant – All-In-One Script (Flipping the Finger to Pay-for-Free Scripts Like CleanMyMac (e)X)

**CleanMac Assistant** is an open-source AppleScript and shell script designed to keep macOS systems clean, fast, and secure—without requiring any paid, closed-source maintenance software. Developed by EasyComp Zeeland, CleanMac Assistant consolidates every maintenance, optimization, and cleanup routine you need into one intuitive script. Consider it the subtle middle finger to CleanMyMac X: no hidden fees, no licensing traps—just a transparent, powerful tool you control.

---

## Table of Contents

1. [Overview](#overview)  
2. [Dependencies](#dependencies)  
3. [Script Structure & Functions](#script-structure--functions)  
   - [Dependency Check](#1-dependency-check)  
   - [Human-Readable Task Names](#2-human-readable-task-names)  
   - [Cleanup & Maintenance Functions](#3-cleanup--maintenance-functions)  
4. [Categories & Tasks](#categories--tasks)  
   - [ℹ️ About](#ℹ️-about)  
   - [🧹 System Cleanup](#🧹-system-cleanup)  
   - [🚀 Performance Optimization](#🚀-performance-optimization)  
   - [🛡️ Privacy Management](#🛡️-privacy-management)  
   - [🔒 Security](#🔒-security)  
   - [📦 App Management](#📦-app-management)  
   - [💾 Disk Usage Analysis](#💾-disk-usage-analysis)  
   - [🚪 Exit](#🚪-exit)  
5. [Usage Instructions](#usage-instructions)  
6. [ECZ Remote Help](#ecz-remote-help)  
7. [Contribution Guidelines](#contribution-guidelines)  
8. [License](#license)  

---

## Overview

Upon launching **CleanMac Assistant**, you are presented with a welcome dialog that emphasizes the initiative’s mission: offering powerful maintenance utilities free of charge. The script credits open-source projects—including Homebrew, ClamAV, and ncdu—and directs users to EasyComp Zeeland’s website for more information. It also highlights ECZ’s remote assistance services for anyone who needs additional help.

Before running any cleanup or maintenance routines, CleanMac Assistant automatically checks that essential dependencies (ClamAV, ncdu, and Homebrew) are installed. If any of those components are missing, the script installs them via Homebrew, displaying a macOS notification each time. This ensures that every feature—ranging from malware scanning to disk usage analysis—can execute without interruption.

---

## Dependencies

CleanMac Assistant relies on three key command-line tools:

1. **Homebrew**  
2. **ClamAV** (for malware scanning)  
3. **ncdu** (for interactive disk usage analysis)  

At the start of execution, the script runs `checkDependencies()`. If any dependency is absent, it invokes Homebrew to install the missing utility:

```applescript
on checkDependencies()
    set dependencies to {"clamav", "ncdu", "brew"}
    repeat with i from 1 to count of dependencies
        set dependency to item i of dependencies
        try
            do shell script "which " & dependency
        on error
            display notification "Installing " & dependency & "..." with title "CleanMac Assistant"
            do shell script "/usr/local/bin/brew install " & dependency
        end try
    end repeat
end checkDependencies
````

---

## Script Structure & Functions

Below is a high-level breakdown of each function in the AppleScript, with English names and descriptions.

### 1. Dependency Check

* **`checkDependencies()`**
  Verifies presence of `clamav`, `ncdu`, and `brew`. If any is missing, installs it via Homebrew and displays a notification.

### 2. Human-Readable Task Names

* **`humanNameFor(taskID)`**
  Converts an internal task identifier (e.g., `"trash"`) into a human-readable English string (e.g., `"Empty Trash"`). This is used when showing dialogs and notifications.

  ```applescript
  on humanNameFor(taak)
      if taak is "trash" then
          return "Empty Trash"
      else if taak is "checkDependencies" then
          return "Check Dependencies"
      else if taak is "cache" then
          return "Clean Cache"
      else if taak is "logs" then
          return "Clean Log Files"
      else if taak is "localizations" then
          return "Remove Localization Files"
      else if taak is "chrome" then
          return "Clean Chrome Cache"
      else if taak is "firefox" then
          return "Clean Firefox Cache"
      else if taak is "ram" then
          return "Free RAM"
      else if taak is "scripts" then
          return "Run Maintenance Scripts"
      else if taak is "dns" then
          return "Flush DNS Cache"
      else if taak is "restart" then
          return "Restart Finder & Flush"
      else if taak is "update" then
          return "Install macOS Updates"
      else if taak is "brew" then
          return "Update Homebrew Packages"
      else if taak is "safari" then
          return "Clear Safari History"
      else if taak is "imessage" then
          return "Delete iMessage Logs"
      else if taak is "cookies" then
          return "Delete Browser Cookies"
      else if taak is "facetime" then
          return "Delete FaceTime Logs"
      else if taak is "malware" then
          return "Perform Malware Scan"
      else if taak is "agents" then
          return "Remove LaunchAgents"
      else if taak is "uninstall" then
          return "Uninstall Application"
      else if taak is "reset" then
          return "Reset Application Preferences"
      else if taak is "disk" then
          return "Analyze Disk Usage"
      else
          return "Unknown Task"
      end if
  end humanNameFor
  ```

### 3. Cleanup & Maintenance Functions

Below are all individual “on <functionName>()” handlers used by CleanMac Assistant, explained in English:

1. **`cleanupTrash()`**
   Empties the user’s Trash folder (`~/.Trash/*`) with administrator privileges.

   ```applescript
   on cleanupTrash()
       do shell script "rm -rf ~/.Trash/*" with administrator privileges
   end cleanupTrash
   ```

2. **`cleanupCache()`**
   Clears user caches by running `xcrun -k`, with notifications before and after execution.

   ```applescript
   on cleanupCache()
       display notification "Starting cache cleanup..." with title "CleanMac Assistant"
       do shell script "xcrun -k"
       display notification "Cache cleanup completed." with title "CleanMac Assistant"
   end cleanupCache
   ```

3. **`cleanupLogs()`**
   Deletes all system log files under `/private/var/log/*`.

   ```applescript
   on cleanupLogs()
       do shell script "sudo rm -rf /private/var/log/*" with administrator privileges
   end cleanupLogs
   ```

4. **`cleanupLocalizations()`**
   Finds and removes all `.lproj` directories in `/Applications`, excluding `en.lproj`.

   ```applescript
   on cleanupLocalizations()
       do shell script "find /Applications -name '*.lproj' ! -name 'en.lproj' -type d -exec rm -rf {} +" with administrator privileges
   end cleanupLocalizations
   ```

5. **`cleanupChrome()`**
   Deletes Chrome’s cache folder at `~/Library/Caches/Google/Chrome/*`.

   ```applescript
   on cleanupChrome()
       do shell script "rm -rf ~/Library/Caches/Google/Chrome/*" with administrator privileges
   end cleanupChrome
   ```

6. **`cleanupFirefox()`**
   Deletes Firefox’s profile cache directories at `~/Library/Caches/Firefox/Profiles/*`.

   ```applescript
   on cleanupFirefox()
       do shell script "rm -rf ~/Library/Caches/Firefox/Profiles/*" with administrator privileges
   end cleanupFirefox
   ```

7. **`freeRAM()`**
   Executes `purge` to free up inactive RAM.

   ```applescript
   on freeRAM()
       do shell script "purge" with administrator privileges
   end freeRAM
   ```

8. **`runMaintenanceScripts()`**
   Loads macOS periodic maintenance daemons (daily, weekly, monthly).

   ```applescript
   on runMaintenanceScripts()
       do shell script "launchctl load /System/Library/LaunchDaemons/com.apple.periodic-daily.plist"
       do shell script "launchctl load /System/Library/LaunchDaemons/com.apple.periodic-weekly.plist"
       do shell script "launchctl load /System/Library/LaunchDaemons/com.apple.periodic-monthly.plist"
   end runMaintenanceScripts
   ```

9. **`flushDNS()`**
   Flushes the DNS cache by running `dscacheutil -flushcache` and sending HUP to mDNSResponder.

   ```applescript
   on flushDNS()
       do shell script "dscacheutil -flushcache; sudo killall -HUP mDNSResponder" with administrator privileges
   end flushDNS
   ```

10. **`restartTools()`**
    Restarts Finder, Dock, and SystemUIServer to refresh the user interface.

    ```applescript
    on restartTools()
        do shell script "killall Finder; killall Dock; killall SystemUIServer" with administrator privileges
    end restartTools
    ```

11. **`systemUpdate()`**
    Installs all available macOS updates via `softwareupdate -ia`.

    ```applescript
    on systemUpdate()
        do shell script "softwareupdate -ia" with administrator privileges
    end systemUpdate
    ```

12. **`brewUpdate()`**
    Runs `brew doctor`, then updates and upgrades all Homebrew packages. Displays notifications on success or error.

    ```applescript
    on brewUpdate()
        set brewPath to do shell script "which brew"
        try
            do shell script brewPath & " doctor" with administrator privileges
            do shell script brewPath & " update --verbose && " & brewPath & " upgrade --verbose" with administrator privileges
            display notification "Homebrew packages updated." with title "CleanMac Assistant"
        on error errMsg number errNum
            display notification "Error updating Homebrew packages: " & errMsg with title "CleanMac Assistant"
        end try
    end brewUpdate
    ```

13. **`safariHistory()`**
    Deletes all Safari browsing history items by running an SQLite command on Safari’s History database.

    ```applescript
    on safariHistory()
        do shell script "sqlite3 ~/Library/Safari/History.db 'DELETE from history_items'" with administrator privileges
    end safariHistory
    ```

14. **`imessageLogs()`**
    Deletes the iMessage chat database files `~/Library/Messages/chat.db*`.

    ```applescript
    on imessageLogs()
        do shell script "rm -rf ~/Library/Messages/chat.db*" with administrator privileges
    end imessageLogs
    ```

15. **`cookiesCleanup()`**
    Deletes all browser cookies stored under `~/Library/Cookies/*`.

    ```applescript
    on cookiesCleanup()
        do shell script "rm -rf ~/Library/Cookies/*" with administrator privileges
    end cookiesCleanup
    ```

16. **`facetimeLogs()`**
    Deletes FaceTime preference logs at `~/Library/Preferences/com.apple.FaceTime.bag.plist`.

    ```applescript
    on facetimeLogs()
        do shell script "rm -rf ~/Library/Preferences/com.apple.FaceTime.bag.plist" with administrator privileges
    end facetimeLogs
    ```

17. **`scanMalware()`**
    Uses ClamAV to recursively scan the entire file system (`/`) for malware. Displays a notification upon completion or error.

    ```applescript
    on scanMalware()
        try
            do shell script "/usr/local/bin/clamscan -r / --verbose" with administrator privileges
            display notification "Malware scan completed." with title "CleanMac Assistant"
        on error errMsg number errNum
            display notification "Error during malware scan: " & errMsg with title "CleanMac Assistant"
        end try
    end scanMalware
    ```

18. **`removeLaunchAgents()`**
    Deletes all LaunchAgents in the user’s library at `~/Library/LaunchAgents/*`.

    ```applescript
    on removeLaunchAgents()
        do shell script "rm -rf ~/Library/LaunchAgents/*" with administrator privileges
    end removeLaunchAgents
    ```

19. **`uninstallApp()`**
    Prompts the user for an application name, then deletes the corresponding `.app` bundle from `/Applications`.

    ```applescript
    on uninstallApp()
        display dialog "Enter the name of the app you want to uninstall:" default answer ""
        set appName to text returned of result
        do shell script "sudo rm -rf /Applications/" & quoted form of appName & ".app" with administrator privileges
    end uninstallApp
    ```

20. **`resetApp()`**
    Prompts for a bundle identifier (e.g., `com.vendor.app`) and runs `defaults delete <bundleID>` to remove all user preferences for that app.

    ```applescript
    on resetApp()
        display dialog "Enter the bundle identifier of the app to reset preferences (e.g., com.vendor.app):" default answer ""
        set bundleID to text returned of result
        do shell script "defaults delete " & bundleID with administrator privileges
    end resetApp
    ```

21. **`analyzeDisk()`**
    Installs `ncdu` via Homebrew (if missing), then opens Terminal to run `ncdu /`. Allows interactive disk usage analysis, and issues a notification on completion or error.

    ```applescript
    on analyzeDisk()
        try
            do shell script "/usr/local/bin/brew install ncdu"
            tell application "Terminal"
                activate
                do script "/usr/local/bin/ncdu /"
            end tell
            display notification "Disk usage analysis completed." with title "CleanMac Assistant"
        on error errMsg number errNum
            display notification "Error analyzing disk usage: " & errMsg with title "CleanMac Assistant"
        end try
    end analyzeDisk
    ```

---

## Categories & Tasks

CleanMac Assistant organizes its functions into these categories (presented in the “choose from list” dialog). Each category contains a set of task IDs that map to the functions described above:

1. **ℹ️ About**
2. **🧹 System Cleanup**

   * `trash`, `cache`, `logs`, `localizations`, `chrome`, `firefox`
3. **🚀 Performance Optimization**

   * `ram`, `scripts`, `dns`, `restart`, `update`, `brew`
4. **🛡️ Privacy Management**

   * `safari`, `imessage`, `cookies`, `facetime`
5. **🔒 Security**

   * `malware`, `agents`
6. **📦 App Management**

   * `uninstall`, `reset`
7. **💾 Disk Usage Analysis**

   * `disk`
8. **🚪 Exit**

Below is how each category is presented and the English descriptions of the tasks within:

### ℹ️ About

* **Display “About” Dialog**

  * Title: *CleanMac Assistant – Your Free Mac Maintenance Tool*
  * Contents:

    * Introduces CleanMac Assistant as EasyComp Zeeland’s free macOS maintenance script.
    * Emphasizes that you don’t need to pay for premium maintenance software (subtle middle finger reference to CleanMyMac X).
    * Credits Homebrew, ClamAV, ncdu, and other open-source projects.
    * Provides links to:

      * EasyComp Zeeland’s website ([https://easycompzeeland.nl](https://easycompzeeland.nl))
      * ECZ Quick Help On a Distance service ([https://easycompzeeland.nl/services/hulp-op-afstand/](https://easycompzeeland.nl/services/hulp-op-afstand/))

### 🧹 System Cleanup

1. **Empty Trash** (`cleanupTrash`)
2. **Clean Cache** (`cleanupCache`)
3. **Clean Log Files** (`cleanupLogs`)
4. **Remove Localization Files** (`cleanupLocalizations`)
5. **Clean Chrome Cache** (`cleanupChrome`)
6. **Clean Firefox Cache** (`cleanupFirefox`)

Each action displays a macOS notification before starting and after completing.

### 🚀 Performance Optimization

1. **Free RAM** (`freeRAM`)
2. **Run Maintenance Scripts** (`runMaintenanceScripts`)

   * Loads Apple’s periodic maintenance daemons (daily, weekly, monthly).
3. **Flush DNS Cache** (`flushDNS`)
4. **Restart Finder & Flush** (`restartTools`)
5. **Install macOS Updates** (`systemUpdate`)
6. **Update Homebrew Packages** (`brewUpdate`)

Each action shows notifications on start, success, or error. The Homebrew update routine also runs `brew doctor` first to check for issues.

### 🛡️ Privacy Management

1. **Clear Safari History** (`safariHistory`)
2. **Delete iMessage Logs** (`imessageLogs`)
3. **Delete Browser Cookies** (`cookiesCleanup`)
4. **Delete FaceTime Logs** (`facetimeLogs`)

### 🔒 Security

1. **Perform Malware Scan** (`scanMalware`)
2. **Remove LaunchAgents** (`removeLaunchAgents`)

### 📦 App Management

1. **Uninstall Application** (`uninstallApp`)

   * Prompts for an application name and removes its `.app` bundle.
2. **Reset Application Preferences** (`resetApp`)

   * Prompts for a bundle identifier and deletes stored preferences.

### 💾 Disk Usage Analysis

1. **Analyze Disk Usage** (`analyzeDisk`)

   * Installs `ncdu` if missing, then opens Terminal to run `ncdu /` for interactive exploration.

### 🚪 Exit

* **Stop Script**

  * Ends the `run` loop and closes the script.

---

## Usage Instructions

1. **Open** `CleanMac Assistant.applescript` in Apple’s Script Editor.
2. **Click** the **Run** button (▶) in Script Editor’s toolbar.
3. A **welcome dialog** appears, prompting you to choose one of the categories listed above.
4. Select a category (e.g., “🧹 System Cleanup”).
5. The script iterates through each task in that category:

   * A **notification** displays “Task X/X: <Human-Readable Task> starting…”.
   * A **dialog** asks: “What would you like to do with <Human-Readable Task>?” with buttons:

     * **Execute**
     * **Skip**
     * **Back**
   * If you choose **Execute**, the corresponding function runs (possibly requesting administrator privileges).
   * On completion, a **notification** indicates success. If an error occurs, a dialog shows the error message with options:

     * **Stop** (abort entire script)
     * **Skip** (skip this task and continue)
     * **Back** (return to previous menu)
6. Continue stepping through tasks until you select **“🚪 Exit”** or cancel a dialog.
7. **Administrator privileges** are requested only when a task requires elevated permissions.

---

## ECZ Remote Help

At EasyComp Zeeland, we discovered that popular remote assistance tools (AnyDesk, TeamViewer) can be:

* **Slow** (laggy connections)
* **Costly** (subscription fees, usage limitations)
* **Incompatible** (occasional issues on macOS, Linux, Windows)

To address these problems, EasyComp Zeeland developed two specialized tools:

1. **ECZ QHOATOOL (Quick Help On A Distance Tool)**

   * **Fast**: Low-latency connections for real-time support.
   * **Secure**: End-to-end encryption ensures your data remains safe.
   * **Expert Support**: Connect directly to EasyComp Zeeland technicians.
   * **Cross-Platform**: Works seamlessly on macOS, Linux, and Windows.

2. **ECZ HOATOOL (Help On A Distance Tool)**

   * **Free & Public**: Anyone—family, friends, or colleagues—can download and use it at no cost.
   * **Easy to Use**: Simple interface for providing or receiving remote assistance.
   * **Cross-Platform**: Compatible with macOS, Linux, and Windows.

Both tools are available for download, along with step-by-step instructions and FAQs, at:

[https://easycompzeeland.nl/services/hulp-op-afstand/](https://easycompzeeland.nl/services/hulp-op-afstand/)

Whether you need direct assistance from an EasyComp Zeeland expert or want to help someone remotely, **ECZ Remote Help** has you covered.

---

## Contribution Guidelines

We welcome contributions to improve CleanMac Assistant’s functionality, reliability, and usability. Here’s how to get involved:

1. **Report Issues**

   * If you encounter a bug or have a feature request, please open an **issue** on this repository with a clear description and steps to reproduce (if applicable).

2. **Fork & Commit**

   * Fork the repository to your GitHub account.
   * Create a new branch for your changes (e.g., `feature/add-new-task`).
   * Implement your changes, ensuring all new code follows the existing style and structure.

3. **Pull Request**

   * Push your branch to your fork.
   * Open a **pull request** against the `main` branch of the upstream repository.
   * Provide a descriptive title and summary of what you changed and why.

4. **Review & Merge**

   * Maintainers will review your pull request and may request changes or clarifications.
   * Once approved, your contribution will be merged, and you will be credited in the commit history.

All contributors will be listed in a **CONTRIBUTORS** section in this README once a community grows.

---

## License

This project is licensed under the **MIT License**. See the **[LICENSE](LICENSE)** file for full terms and conditions.

---

```
```
