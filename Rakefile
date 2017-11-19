# run rake -T to see available tasks to run
# run rake -P to see all tasks and dependencies

desc "Add a layer of protection against inadvertent running"
task :default do
    puts "Please run rake -T to see available tasks"
end


desc "Determine Operating System and Package manager to use"
task :determine_os do
    puts "Determining your Operating System and Package Manager"
    kernel_name = `echo $(uname)`.chomp
    case kernel_name
    when "Darwin"
        $install_os = "mac"
        $pckg_mgr = "homebrew"
    when "Linux"
	#Determine the distro to set the right package manager
        version = `cat /proc/version/` 
        if (version =~ /Debian/) then
            $install_os = "linux" #Debian and Ubuntu
            $pckg_mgr = "apt-get"
        else
            # To be updated for Fedora, Red Hat
	    exit "Your OS is not supported"
        end
    end
    puts "Proceeding with installation for #{$install_os} using #{$pckg_mgr}"
end


desc "Install build tools"
task :install_build_tools  => [:determine_os] do
    puts "Installing command line build tools"
    case $install_os
    when "mac" # install the Xcode command line tools (compilers mainly)
        puts "Installing Xcode command line tools..."
	if File.directory?(`xcode-select -p`.chomp) then
	    puts "Xcode CLI already installed!"
	else
	    system "sudo xcode-select --install"
	    system "sudo xcodebuild --license approve"
	    puts "Done!"
	end

	puts "Installing homebrew package manager for #{$install_os}"
	if `which brew` =~ /brew/ then
	    puts "Homebrew is already installed. Updating Homebrew..."
	    system "brew doctor"
	    system "brew update"
	    system "brew update"
	else
	    system "/usr/bin/ruby -e #{ %Q{$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install) } }"
	    system "brew doctor"
	    system "brew update"
	    system "brew update"
	    puts "Homebrew done!"
	end

    when "linux"
	puts "Getting build tools"
	system "sudo #{$pckg_mgr} update"
        system "sudo #{$pckg_mgr} install build-essential"	
    end
end


desc "Install apps from list (Brewfile or apt)"
task :install_apps => [:install_build_tools] do
	case $pckg_mgr
	when "homebrew"
		system "brew bundle --file=package/Brewfile"
	when "apt-get"
		system "source package/Aptfile.sh"
	end
end


desc "Set up Git"
task :setup_git do
    puts "Setting up Git"
    puts "Please enter your full user name: "
    user_name = STDIN.gets.chomp
    puts "Please enter your Git user email: "
    user_email = STDIN.gets.chomp

    puts "Setting autocrlf to false"
    system "git config --global core.autocrlf false"
    
    puts "Setting Git user name to #{ %Q{ user_name } }"
    system %Q[git config --global user.name "#{ user_name }"]

    puts "Setting Git user email to #{ user_email }"
    system "git config --global user.email #{ user_email }"

    puts "Setting Git core editor to vim"
    system "git config --global core.editor vim"
end


desc "Setup Zshell and oh-my-zsh framework"
task :setup_zsh => [:install_apps] do
    # At this point, the newest Zsh version should be in PATH, via Homebrew, apt-get, etc.
    puts "Setting up Zshell."
    if ENV["SHELL"] =~ /zsh/  
        puts "Using zsh already."
    else
        puts "Switching to zsh..."
        if `grep "$(which zsh)" /etc/shells` == ""
            puts "Putting zsh in approved shells -> /etc/shells"
            system %Q{echo `which zhs` | sudo tee -a /etc/shells}
        end
        puts "Changing default shell to Zsh (chsh -s)"
        system %Q{chsh -s `which zsh`}
        system %Q{export SHELL=`which zsh`} #Only for this session
    end

    puts "Setting up Oh-my-zsh..."
    if File.directory?("~/.oh-my-zsh") then
    	puts "Oh-my-zsh already installed!"
	#Perhaps find a way to automatically trigger an update of Oh-my-zsh
    else
	puts "Fetching and installing Oh-my-zsh."
	system %Q[sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"]
	puts "Oh-my-zsh installation done."
    end

end

desc "Symlink dotfiles"
task :link_dotfiles do
    # link dotfiles to their proper directories
	# Check if the current file exists
	  # Yes: Check if the current file is a link
	    # Yes: Check if it is a link to the right file
	#Dir.foreach(dirname) { |filename| block }
	
	filename = ".vimrc"
	rcdir = File.join(Dir.pwd, "rc")
	link_with_options(rcdir, Dir.home, filename)
end

desc "Perform complete install"
task :install_complete => [:install_apps, :link_dotfiles, :setup_git] do
    puts "Performing complete install."
end




# HELPER METHODS BELOW HERE

def link_with_options(rcdir, targetdir, filename)
	in_file = File.join(rcdir, filename)
	out_file = File.join(targetdir, filename)

	if File.exists? out_file then
	    puts "The file #{ out_file } already exists. Do you want to..."
	    c = get_user_choice(%w(o b s), %Q{(o)verwrite, (b)ackup and replace, or (s)kip?})
	    
	    case c
	    when 'o'
		puts "Overwriting..."    
		puts "Creating symlink #{in_file} -> #{out_file}." 
		FileUtils.rm(out_file)
		FileUtils.ln_s(in_file, out_file)

	    when 'b'
		timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
		backup_file = out_file + ".bak-" + timestamp
		puts "Backing up to #{backup_file}..."
		puts "Creating symlink #{in_file} -> #{out_file}." 
		FileUtils.cp(out_file, backup_file)
		FileUtils.rm(out_file)
		FileUtils.ln_s(in_file, out_file)

	    when 's'
		# pass
		puts "Skipping #{in_file}..."
	    end	
	
	else #File does not exist
	    # symlink in_file out_file
		puts "Creating symlink #{in_file} -> #{out_file}." 
		FileUtils.ln_s(in_file, out_file)
	end
end

def get_user_choice(choice_array, annotation_string)
    user_choice = ""
    while ( !choice_array.include? user_choice )
	puts annotation_string
	user_choice = STDIN.gets.chomp
    end
    return user_choice
end

