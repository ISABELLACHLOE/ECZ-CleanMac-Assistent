-- CleanMac Assistant – all-in-one script
on checkDependencies()
	set dependencies to {"clamav", "ncdu", "brew"}
	repeat with i from 1 to count of dependencies
		set dependency to item i of dependencies
		try
			do shell script "which " & dependency
		on error
			display notification "Installing " & dependency & "..."
			do shell script "/usr/local/bin/brew install " & dependency
		end try
	end repeat
end checkDependencies

on humanNameFor(task)
	if task is "trash" then
		return "Empty Trash"
	else if task is "checkDependencies" then
		return "Check Dependencies (such as)"
	else if task is "cache" then
		return "Clear Cache"
	else if task is "logs" then
		return "Clear Log Files"
	else if task is "localizations" then
		return "Remove Language Files"
	else if task is "chrome" then
		return "Clear Chrome Cache"
	else if task is "firefox" then
		return "Clear Firefox Cache"
	else if task is "ram" then
		return "Free Up RAM"
	else if task is "scripts" then
		return "Run Maintenance Scripts"
	else if task is "dns" then
		return "Flush DNS Cache"
	else if task is "restart" then
		return "Restart and Flush Finder"
	else if task is "update" then
		return "Install macOS Updates"
	else if task is "brew" then
		return "Update Homebrew Packages"
	else if task is "safari" then
		return "Clear Safari History"
	else if task is "imessage" then
		return "Clear iMessage Logs"
	else if task is "cookies" then
		return "Clear Browser Cookies"
	else if task is "facetime" then
		return "Clear FaceTime Logs"
	else if task is "malware" then
		return "Run Malware Scan"
	else if task is "agents" then
		return "Remove Launch Agents"
	else if task is "uninstall" then
		return "Uninstall App"
	else if task is "reset" then
		return "Reset App"
	else if task is "disk" then
		return "Analyze Disk Usage"
	else
		return "Unknown Task"
	end if
end humanNameFor

-- Task handlers
on cleanupTrash()
	do shell script "rm -rf ~/.Trash/*" with administrator privileges
end cleanupTrash

on cleanupCache()
	display notification "Clearing Cache..." with title "CleanMac Assistant"
	do shell script "xcrun -k"
	display notification "Cache cleared." with title "CleanMac Assistant"
end cleanupCache

on cleanupLogs()
	do shell script "sudo rm -rf /private/var/log/*" with administrator privileges
end cleanupLogs

on cleanupLocalizations()
	do shell script "find /Applications -name '*.lproj'! -name 'en.lproj' -type d -exec rm -rf {} +" with administrator privileges
end cleanupLocalizations

on cleanupChrome()
	do shell script "rm -rf ~/Library/Caches/Google/Chrome/*" with administrator privileges
end cleanupChrome

on cleanupFirefox()
	do shell script "rm -rf ~/Library/Caches/Firefox/Profiles/*" with administrator privileges
end cleanupFirefox

on freeRAM()
	do shell script "purge" with administrator privileges
end freeRAM

on runMaintenanceScripts()
	do shell script "launchctl load /System/Library/LaunchDaemons/com.apple.periodic-daily.plist"
	do shell script "launchctl load /System/Library/LaunchDaemons/com.apple.periodic-weekly.plist"
	do shell script "launchctl load /System/Library/LaunchDaemons/com.apple.periodic-monthly.plist"
end runMaintenanceScripts

on flushDNS()
	do shell script "dscacheutil -flushcache; sudo killall -HUP mDNSResponder" with administrator privileges
end flushDNS

on restartTools()
	do shell script "killall Finder; killall Dock; killall SystemUIServer" with administrator privileges
end restartTools

on systemUpdate()
	do shell script "softwareupdate -ia" with administrator privileges
end systemUpdate

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

on safariHistory()
	do shell script "sqlite3 ~/Library/Safari/History.db 'DELETE from history_items'" with administrator privileges
end safariHistory

on imessageLogs()
	do shell script "rm -rf ~/Library/Messages/chat.db*" with administrator privileges
end imessageLogs

on cookiesCleanup()
	do shell script "rm -rf ~/Library/Cookies/*" with administrator privileges
end cookiesCleanup

on facetimeLogs()
	do shell script "rm -rf ~/Library/Preferences/com.apple.FaceTime.bag.plist" with administrator privileges
end facetimeLogs

on scanMalware()
	try
		do shell script "/usr/local/bin/clamscan -r / --verbose" with administrator privileges
		display notification "Malware scan completed." with title "CleanMac Assistant"
	on error errMsg number errNum
		display notification "Error running malware scan: " & errMsg with title "CleanMac Assistant"
	end try
end scanMalware

on removeLaunchAgents()
	do shell script "rm -rf ~/Library/LaunchAgents/*" with administrator privileges
end removeLaunchAgents

on uninstallApp()
	display dialog "Enter the name of the app you want to uninstall:" default answer ""
	set appName to text returned of result
	do shell script "sudo rm -rf /Applications/" & quoted form of appName & ".app" with administrator privileges
end uninstallApp

on resetApp()
	display dialog "Enter the name of the app to reset preferences (com.vendor.app):" default answer ""
	set bundleID to text returned of result
	do shell script "defaults delete " & bundleID with administrator privileges
end resetApp

on analyzeDisk()
	try
		do shell script "/usr/local/bin/brew install ncdu"
		tell application "Terminal"
			activate
			do script "/usr/local/bin/ncdu /"
		end tell
		display notification "Disk usage analyzed." with title "CleanMac Assistant"
	on error errMsg number errNum
		display notification "Error analyzing disk usage: " & errMsg with title "CleanMac Assistant"
	end try
end analyzeDisk

-- Main script
on run
	set actions to {¬
		{"trash", "cache", "logs", "localizations", "chrome", "firefox"}, ¬
		{"ram", "scripts", "dns", "restart", "update", "brew"}, ¬
		{"safari", "imessage", "cookies", "facetime"}, ¬
		{"malware", "agents"}, ¬
		{"uninstall", "reset"}, ¬
		{"disk"}}
	
	set categories to {"ℹ️ About", "🧹 System Cleaning", "🚀 Performance Optimization", "🛡️ Privacy Management", "🔒 Security", "📦 App Management", "💾 Disk Usage", "🚪 Quit"}
	
	repeat
		set choice to choose from list categories with prompt "Welcome to CleanMac Assistant – the free maintenance tool from EasyComp Zeeland.

Keep your Mac super fast, secure, and clean,
without unnecessary costs.

Why pay for something that we do for free and better?

Click on 'ℹ️ About' for more information,
or make a selection from the options below." default items {"ℹ️ About"}
		if choice is false then return
		set action to item 1 of choice
		
		if action is "🚪 Quit" then return
		
		if action is "ℹ️ About" then
			display dialog "CleanMac Assistant – Your free Mac maintenance assistant" & return & ¬
				"An initiative of EasyComp Zeeland – Your trusted partner in smart and accessible IT solutions." & return & return & ¬
				"Why pay for expensive maintenance software?" & return & ¬
				"CleanMac Assistant provides you with powerful tools to keep your Mac clean, fast, and secure, free of charge. Think of removing temporary files, clearing system cache, monitoring processes, and improving overall system performance – all easy, transparent, and without hidden costs." & return & return & ¬
				"This tool was developed with attention to detail, user-friendliness, and reliability by the EasyComp Zeeland team." & return & ¬
				"We would like to thank: Homebrew, ClamAV, and all other open-source projects that make CleanMac Assistant possible." & return & return & ¬
				"More info: https://easycompzeeland.nl" & return & return & ¬
				"Support via ECZQHOA: https://easycompzeeland.nl/en/services/hulp-op-afstand" & return & return & ¬
				"CleanMac Assistant – because smart technology should be accessible to everyone." & return & ¬
				"And for all expensive maintenance tools: save your money, choose CleanMac Assistant!" buttons {"OK"} default button "OK"
		else
			-- Find index of chosen category
			set catIndex to 0
			repeat with i from 1 to (count categories)
				if item i of categories is action then
					set catIndex to i
					exit repeat
				end if
			end repeat
			
			if catIndex is 0 then
				display dialog "Category not found!" buttons {"OK"} default button 1
				return
			end if
			
			-- Get tasks that belong to the category (categories start at 1, actions start at 1, but actions has 6 items, categories has 8)
			if catIndex > 1 and catIndex ≤ ((count actions) + 1) then
				set tasks to item (catIndex - 1) of actions
			else
				display dialog "No actions available for this category." buttons {"OK"} default button 1
				return
			end if
			
			set total to count of tasks
			
			repeat with i from 1 to total
				set taskID to item i of tasks
				set humanName to humanNameFor(taskID)
				
				display notification "Task " & i & "/" & total & ": " & humanName & " started..." with title "CleanMac Assistant"
				set choice to button returned of (display dialog "What do you want to do with " & humanName & "?" buttons {"Back", "Skip", "Run"} default button "Run")
				
				if choice is "Back" then exit repeat
				if choice is "Skip" then
					display notification humanName & " skipped." with title "CleanMac Assistant"
				else
					try
						if taskID is "trash" then
							cleanupTrash()
						else if taskID is "cache" then
							cleanupCache()
						else if taskID is "logs" then
							cleanupLogs()
						else if taskID is "localizations" then
							cleanupLocalizations()
						else if taskID is "chrome" then
							cleanupChrome()
						else if taskID is "firefox" then
							cleanupFirefox()
						else if taskID is "ram" then
							freeRAM()
						else if taskID is "scripts" then
							runMaintenanceScripts()
						else if taskID is "dns" then
							flushDNS()
						else if taskID is "restart" then
							restartTools()
						else if taskID is "update" then
							systemUpdate()
						else if taskID is "brew" then
							brewUpdate()
						else if taskID is "safari" then
							safariHistory()
						else if taskID is "imessage" then
							imessageLogs()
						else if taskID is "cookies" then
							cookiesCleanup()
						else if taskID is "facetime" then
							facetimeLogs()
						else if taskID is "malware" then
							scanMalware()
						else if taskID is "agents" then
							removeLaunchAgents()
						else if taskID is "uninstall" then
							uninstallApp()
						else if taskID is "reset" then
							resetApp()
						else if taskID is "disk" then
							analyzeDisk()
						end if
						display notification humanName & " completed." with title "CleanMac Assistant"
					on error errMsg number errNum
						set errChoice to button returned of (display dialog humanName & " failed:" & return & errMsg & return & "What do you want to do?" buttons {"Quit", "Skip", "Back"} default button "Skip")
						if errChoice is "Quit" then return
						if errChoice is "Back" then exit repeat
						display notification humanName & " skipped." with title "CleanMac Assistant"
					end try
				end if
			end repeat
		end if
	end repeat
end run
