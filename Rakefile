# run rake -T to see available tasks to run
# run rake -P to see all tasks and dependencies

desc "Determine Operating System and Package manager to use"
task :determine_os do
    kernel = `$(uname)`.chomp
    case kernel
    when "Darwin"
        #
        install_os = "mac"
        pckg_mgr = "homebrew"
    when "Linux"
        version = `cat /proc/version/` 
        if (version =~ /Debian/) then
            install_os = "debian" #Debian and Ubuntu
            pckg_mgr = "apt"
        else
            # To be updated for Fedora, Red Hat
        end
    end
end

desc "Install command line tools"
task :install_commandline do
    # 
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
end

desc "Install apps from homebrew"
task :install_apps => [:install_homebrew] do
    puts "Installing apps via Homebrew..."
    `brew bundle`
end

desc "Set up Git"
task :setup_git => [:install_apps] do
    puts "Setting up Homebrewed Git"
    # git config --global core.autocrlf input
    # git config --global user.name = "Janus Bo Andersen"
    # git config --globl user.email janus@janusboandersen.dk
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
