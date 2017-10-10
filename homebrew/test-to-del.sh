#!/bin/sh

if test ! $(which brew)
then
    echo "Homebrew not installed"
else
    echo "Homebrew is installed"
fi

