#!/usr/bin/env ruby

require 'optparse'
require 'redcarpet'

# Set default values for the theme and dir options
DEFAULT_THEME = "default"
DEFAULT_DIR = "posts"

# Parse command line options
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ballast.rb [options]"

  opts.on("-d DIR", "--dir DIR", "Directory containing Markdown files") do |dir|
    options[:dir] = dir
  end

  opts.on("-t THEME", "--theme THEME", "Name of theme to use") do |theme|
    options[:theme] = theme
  end
end.parse!

# Use the default theme if no theme was specified
options[:theme] ||= DEFAULT_THEME

# Use the default dir if no dir was specified
options[:dir] ||= DEFAULT_DIR

# Check if the "build" directory exists
unless Dir.exist?("build")
  # Create the "build" directory if it doesn't exist
  Dir.mkdir("build")
end

# Iterate over all Markdown files in the specified directory
Dir.glob("#{options[:dir]}/*.md") do |markdown_file|
  # Read the Markdown file
  markdown = File.read(markdown_file)

  # Extract the front matter metadata using a regular expression
  front_matter_match = markdown.match(/^---\n(.*?)\n---\n(.*)/m)
  front_matter = front_matter_match[1]
  content = front_matter_match[2]

  # Parse the front matter metadata into a hash
  metadata = {}
  front_matter.each_line do |line|
    key, value = line.split(":")
    metadata[key.strip] = value.strip
  end

  # Extract the title from the metadata
  title = metadata["title"]

  # Convert the content to HTML
  html = Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(content)

  # Read the theme file
  theme_file = File.read("themes/#{options[:theme]}.css")

  # Generate the HTML for the blog post by inserting the post content and title into the theme HTML
  post_html = "<html>\n<head>\n<title>#{title}</title>\n<style>\n#{theme_file}</style>\n</head>\n<body>\n</h1>\n#{html}\n</body>\n</html>"

  # Get the name of the Markdown file without the extension
  html_filename = File.basename(markdown_file, ".md")

  # Write the HTML to a file in the "build" directory
  File.write("build/#{html_filename}.html", post_html)
end
