# This file will run commands to install various apps

sudo yum update			# Refresh package list
sudo yum install rpmbuild	# Various compilers (GCC, etc.)
sudo yum install wget curl		# Utils for fetching resources over network
sudo yum install zsh			# Z shell


#Install RVM
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB #install the developers public GPG key

\curl -sSL https://get.rvm.io | bash -s stable --ruby #install with stable ruby

