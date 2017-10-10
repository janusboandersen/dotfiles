# run rake -T to see available tasks to run
# run rake -P to see all tasks and dependencies

desc "Install Xcode command line tools"
task :install_xcode do
    # install the Xcode command line tools (compilers mainly)
    #if File.exist? `xcode-select -p`
    `xcode-select --install`
    `xcodebuild --license approve`
end

desc "Install homebrew: brew and cask"
task :install_homebrew do
    puts "Installing homebrew..."
    if `which brew` =~ /brew/
        puts "Homebrew already installed, updating..."
        `brew update`
    else
        #Get homebrew boostrapped with ruby

        `brew doctor`
        `brew update`
        `brew update`
    end

    puts "Bundling all apps from Brewfile"
    `brew bundle`

end

desc "Install apps from homebrew"
task :install_apps => [:install_homebrew] do
    puts "Installing apps via Homebrew..."
end

desc "Install Zshell and oh-my-zsh library"
task :install_zsh do
    if ENV["SHELL"] =~ /zsh/  #pattern matching
        puts "Using zsh already."
    else
        puts "Switching to zsh..."
        if `grep "$(which zsh)" /etc/shells` == ""
            puts "Putting zsh in approved shells -> /etc/shells"
            system %Q{echo `which zhs` | sudo tee -a /etc/shells}
        end
        puts "Setting chsh."
        system %Q{chsh -s `which zsh`}
        system %Q{export SHELL=`which zsh`}
    end 
end

desc "Symlink dotfiles"
task :install_dotfiles => [:install_homebrew, :install_zsh, :install_apps] do
    # link dotfiles to their proper directories
end
