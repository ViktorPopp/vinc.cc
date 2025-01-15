require "open-uri"

set :source, "src"

Time.zone = 'UTC'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: false, autolink: true, tables: true

page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false

activate :syntax

activate :directory_indexes

activate :breadcrumbs, separator: " / "

activate :blog do |blog|
  blog.prefix = "news"
  blog.layout = "layouts/news"
  blog.tag_template = "news/tag.html"
  blog.calendar_template = "news/calendar.html"
end

configure :build do
  activate :minify_css
  activate :minify_javascript
end

# Run `touch src/software/.sync` to update this directory
if File.exist?("src/software/projects/.sync")
  projects = %w[
    chatai
    closh
    forecaster
    geocal
    geodate
    littlewing
    memorious
    moros
    ned
    oximon
    pkg
    purplehaze
    timetable
    ytdl
  ]

  projects.each do |project|
    base = "https://raw.githubusercontent.com/vinc/#{project}/master"
    url = "#{base}/README.md"
    puts "Fetching '#{url}' ..."
    name = project.tr(".", "-")
    path = "src/software/projects/#{name}.html.md"
    File.open(path, "w") do |f|
      URI.open(url) do |io|
        f.write("---\ntitle: #{project.capitalize}\n---\n")
        f.write(io.read.gsub(/\[(.*)\]\(((?!http).*)\)/, "[\\1](#{base}/\\2)"))
      end
    end
  end
  File.unlink("src/software/projects/.sync")
end

ready do
  sitemap.resources.each do |resource|
    next unless resource.data.title.nil?

    case resource.locals["page_type"]
    when "tag"
      resource.data.title = resource.locals["tagname"].capitalize
    when "year", "month", "day"
      resource.data.title = resource.locals[resource.locals["page_type"]].to_s
    end
  end
end
