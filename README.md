# Ballast - a simple blog generator in Ruby

Use -d to specify the directory containing the markdown files

Use -t to specify the theme located in the themes directory

Example: ruby ballast.rb -d input_dir -t fuzzy

This would read the .md files located in the directory 'input_dir' and read the css theme in the themes folder 'fuzzy.css'

The default if the flags aren't passed are "posts" for the directory and "default" for the theme
