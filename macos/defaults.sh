#!/bin/bash

#### Sets macOS defaults

# Install dockutil
curl -sSfLO "https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg"
sudo installer -pkg dockutil-3.0.2.pkg -target /
rm dockutil-3.0.2.pkg

##### Finder #####
# Open everything in list view
defaults write com.apple.Finder FXPreferredViewStyle Nlsv
# Show the ~/Library folder.
chflags nohidden ~/Library
# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true
# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

##### Dock #####
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true
# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true
# Don't show recently used applications in the Dock
defaults write com.Apple.Dock show-recents -bool false

##### General #####
# Switch to dark mode
sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

##### VSCode #####
# Enable repeats when holding down keys 
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

##### XCode #####
# Show Build Times
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES

##### Dock Applications #####
dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/System/Applications/Utilities/Terminal.app"
dockutil --no-restart --add "/System/Applications/Music.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
xcode_path=$(xcode-select -p)
dockutil --no-restart --add "${xcode_path%%/Contents/Developer}"

##### Restart Apps ######
for app in "Dock" "Finder"; do
    killall "$app" &> /dev/null
done
