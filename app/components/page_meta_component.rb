# frozen_string_literal: true

class PageMetaComponent < ApplicationComponent
  option :title
  option :description
  # option :url_path

  erb_template <<~ERB

    <link rel='canonical' href="<%= [ENV.fetch('BASE_URL'), @url_path&.gsub(ENV.fetch('BASE_URL'), '')].join("/") %>" />
    <meta name="description" content="<%= @description.strip %>" />
    
    <meta property="og:title" content="<%= @title %>" />
    <meta property="og:type" content="article" />
    <meta property="og:url" content="<%= [ENV.fetch('BASE_URL'), @url_path&.gsub(ENV.fetch('BASE_URL'), '')].join("/") %>" />
    <meta property="og:image" content="https://img.ogimage.app/image/generate?pattern=lips&site=quizzies.app&title=<%= @title %>&description=<%= @description.strip %>&accent=214352" />
    <meta property="og:description" content="<%= @description.strip %>" />


  ERB
end
# <meta name="twitter:card" content="summary_large_image">
#   <meta name="twitter:site" content="@quizzies">
#   <meta name="twitter:title" content="<%= @title %>">
#   <meta name="twitter:description" content="<%= @description.strip %>">
#   <meta name="twitter:image:alt" content="<%= @description.strip %>">
#   <meta name="twitter:image:src" content="https://img.ogimage.app/image/generate?pattern=lips&site=serpboard.com&title=<%= @title %>&description=<%= @description.strip %>&accent=374151">
