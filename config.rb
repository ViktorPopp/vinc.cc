set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, autolink: true

page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false

activate :syntax

activate :breadcrumbs, separator: " / "

activate :blog do |blog|
  blog.prefix = "blog"
  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  blog.layout = "layouts/blog"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"
  blog.tag_template = "blog/tag.html"
  blog.calendar_template = "blog/calendar.html"
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

activate :deploy do |deploy|
  deploy.deploy_method = :sftp
  deploy.host          = "vinc.cc"
  deploy.path          = "/home/user-data/www/vinc.cc"
  deploy.user          = "root"
end

configure :build do
  # activate :minify_css
  # activate :minify_javascript
end

redirect "bin/index.html", to: "/binaries"
redirect "biography.html", to: "about.html"

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
