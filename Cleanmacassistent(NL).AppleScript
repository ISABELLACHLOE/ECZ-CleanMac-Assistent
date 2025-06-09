-- CleanMac Assistant – alles-in-één script
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

on humanNameFor(taak)
	if taak is "trash" then
		return "Prullenmand legen"
	else if taak is "checkDependencies" then
		return "Afhankelijkheden controleren (zoals)"
	else if taak is "cache" then
		return "Cache opschonen"
	else if taak is "logs" then
		return "Logbestanden opschonen"
	else if taak is "localizations" then
		return "Taalbestanden verwijderen"
	else if taak is "chrome" then
		return "Chrome-cache verwijderen"
	else if taak is "firefox" then
		return "Firefox-cache verwijderen"
	else if taak is "ram" then
		return "RAM vrijmaken"
	else if taak is "scripts" then
		return "Onderhoudsscripts uitvoeren"
	else if taak is "dns" then
		return "DNS-cache flushen"
	else if taak is "restart" then
		return "Herstart en Flush Finder"
	else if taak is "update" then
		return "macOS updates installeren"
	else if taak is "brew" then
		return "Homebrew pakketten bijwerken"
	else if taak is "safari" then
		return "Safari geschiedenis verwijderen"
	else if taak is "imessage" then
		return "iMessage logs verwijderen"
	else if taak is "cookies" then
		return "Browser cookies verwijderen"
	else if taak is "facetime" then
		return "FaceTime logs verwijderen"
	else if taak is "malware" then
		return "Malware scan uitvoeren"
	else if taak is "agents" then
		return "LaunchAgents verwijderen"
	else if taak is "uninstall" then
		return "App deïnstalleren"
	else if taak is "reset" then
		return "App resetten"
	else if taak is "disk" then
		return "Schijfgebruik analyseren"
	else
		return "Onbekende taak"
	end if
end humanNameFor

-- Taken handlers
on cleanupTrash()
	do shell script "rm -rf ~/.Trash/*" with administrator privileges
end cleanupTrash

on cleanupCache()
	display notification "Cache opschonen wordt gestart..." with title "CleanMac Assistant"
	do shell script "xcrun -k"
	display notification "Cache opschonen is voltooid." with title "CleanMac Assistant"
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
		display notification "Homebrew pakketten zijn bijgewerkt." with title "CleanMac Assistant"
	on error errMsg number errNum
		display notification "Fout bij het bijwerken van Homebrew pakketten: " & errMsg with title "CleanMac Assistant"
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
		display notification "Malware scan is voltooid." with title "CleanMac Assistant"
	on error errMsg number errNum
		display notification "Fout bij het uitvoeren van malware scan: " & errMsg with title "CleanMac Assistant"
	end try
end scanMalware


on removeLaunchAgents()
	do shell script "rm -rf ~/Library/LaunchAgents/*" with administrator privileges
end removeLaunchAgents

on uninstallApp()
	display dialog "Voer de naam van de app in die je wilt verwijderen:" default answer ""
	set appName to text returned of result
	do shell script "sudo rm -rf /Applications/" & quoted form of appName & ".app" with administrator privileges
end uninstallApp

on resetApp()
	display dialog "Voer de naam van de app in om voorkeuren te resetten (com.vendor.app):" default answer ""
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
		display notification "Schijfgebruik is geanalyseerd." with title "CleanMac Assistant"
	on error errMsg number errNum
		display notification "Fout bij het analyseren van schijfgebruik: " & errMsg with title "CleanMac Assistant"
	end try
end analyzeDisk


-- Hoofdscript
on run
	set acties to {¬
		{"trash", "cache", "logs", "localizations", "chrome", "firefox"}, ¬
		{"ram", "scripts", "dns", "restart", "update", "brew"}, ¬
		{"safari", "imessage", "cookies", "facetime"}, ¬
		{"malware", "agents"}, ¬
		{"uninstall", "reset"}, ¬
		{"disk"}}
	
	set categorieen to {"ℹ️ Over", "🧹 Systeemopschoning", "🚀 Prestatieoptimalisatie", "🛡️ Privacybeheer", "🔒 Beveiliging", "📦 Appbeheer", "💾 Schijfgebruik", "🚪 Stoppen"}
	
	repeat
		set keuze to choose from list categorieen with prompt "Welkom bij CleanMac Assistent – de gratis onderhoudstool van EasyComp Zeeland.

Houd uw Mac razendsnel, veilig en schoon,
zónder onnodige kosten.

Waarom betalen voor iets dat wij gratis én beter doen?

Klik op ‘ℹ️Over’ voor meer informatie,
of maak direct een keuze uit de onderstaande opties." default items {"ℹ️ Over"}
		if keuze is false then return
		set actie to item 1 of keuze
		
		if actie is "🚪 Stoppen" then return
		
		if actie is "ℹ️ Over" then
			display dialog "CleanMac Assistant – Uw gratis Mac-onderhoudsassistent" & return & ¬
				"Een initiatief van EasyComp Zeeland – Uw vertrouwde partner in slimme en toegankelijke IT-oplossingen." & return & return & ¬
				"Waarom betalen voor dure onderhoudssoftware?" & return & ¬
				"CleanMac Assistant biedt u kosteloos krachtige hulpmiddelen om uw Mac schoon, snel en veilig te houden. Denk aan het verwijderen van tijdelijke bestanden, het opschonen van systeemcache, het monitoren van processen en het verbeteren van de algehele systeemprestaties – allemaal eenvoudig, transparant en zonder verborgen kosten." & return & return & ¬
				"Deze tool is ontwikkeld met oog voor detail, gebruiksgemak en betrouwbaarheid door het team van EasyComp Zeeland." & return & ¬
				"We willen graag bedanken: Homebrew, ClamAV en alle andere open-source projecten die we gebruiken om CleanMac Assistant mogelijk te maken." & return & ¬
				"Meer info: https://easycompzeeland.nl" & return & return & ¬
				"Ondersteuning via ECZQHOA: https://easycompzeeland.nl/en/services/hulp-op-afstand" & return & return & ¬
				"CleanMac Assistant – omdat slimme technologie voor iedereen toegankelijk hoort te zijn." & return & ¬
				"En voor alle dure onderhoudstools: spaar je geld, kies voor CleanMac Assistant!" buttons {"OK"} default button "OK"
		else
			-- Vind index van gekozen categorie
			set catIndex to 0
			repeat with i from 1 to (count categorieen)
				if item i of categorieen is actie then
					set catIndex to i
					exit repeat
				end if
			end repeat
			
			if catIndex is 0 then
				display dialog "Categorie niet gevonden!" buttons {"OK"} default button 1
				return
			end if
			
			-- Haal de taken op die bij de categorie horen (categorieen start op 1, acties op 1, maar acties heeft 6 items, categorieen 8)
			if catIndex > 1 and catIndex ≤ ((count acties) + 1) then
				set taken to item (catIndex - 1) of acties
			else
				display dialog "Geen acties beschikbaar voor deze categorie." buttons {"OK"} default button 1
				return
			end if
			
			set totaal to count of taken
			
			repeat with i from 1 to totaal
				set taakID to item i of taken
				set humanName to humanNameFor(taakID)
				
				display notification "Taak " & i & "/" & totaal & ": " & humanName & " wordt gestart..." with title "CleanMac Assistant"
				set choice to button returned of (display dialog "Wat wil je met " & humanName & " doen?" buttons {"Terug", "Overslaan", "Uitvoeren"} default button "Uitvoeren")
				
				if choice is "Terug" then exit repeat
				if choice is "Overslaan" then
					display notification humanName & " overgeslagen." with title "CleanMac Assistant"
				else
					try
						if taakID is "trash" then
							cleanupTrash()
						else if taakID is "cache" then
							cleanupCache()
						else if taakID is "logs" then
							cleanupLogs()
						else if taakID is "localizations" then
							cleanupLocalizations()
						else if taakID is "chrome" then
							cleanupChrome()
						else if taakID is "firefox" then
							cleanupFirefox()
						else if taakID is "ram" then
							freeRAM()
						else if taakID is "scripts" then
							runMaintenanceScripts()
						else if taakID is "dns" then
							flushDNS()
						else if taakID is "restart" then
							restartTools()
						else if taakID is "update" then
							systemUpdate()
						else if taakID is "brew" then
							brewUpdate()
						else if taakID is "safari" then
							safariHistory()
						else if taakID is "imessage" then
							imessageLogs()
						else if taakID is "cookies" then
							cookiesCleanup()
						else if taakID is "facetime" then
							facetimeLogs()
						else if taakID is "malware" then
							scanMalware()
						else if taakID is "agents" then
							removeLaunchAgents()
						else if taakID is "uninstall" then
							uninstallApp()
						else if taakID is "reset" then
							resetApp()
						else if taakID is "disk" then
							analyzeDisk()
						end if
						display notification humanName & " voltooid." with title "CleanMac Assistant"
					on error errMsg number errNum
						set errChoice to button returned of (display dialog humanName & " mislukt:" & return & errMsg & return & "Wat wil je doen?" buttons {"Stoppen", "Overslaan", "Terug"} default button "Overslaan")
						if errChoice is "Stoppen" then return
						if errChoice is "Terug" then exit repeat
						display notification humanName & " overgeslagen." with title "CleanMac Assistant"
					end try
				end if
			end repeat
		end if
	end repeat
end run
