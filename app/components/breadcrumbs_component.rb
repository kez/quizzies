# frozen_string_literal: true

class BreadcrumbsComponent < ApplicationComponent
  option :items

  erb_template <<~ERB
    <div class="text-sm breadcrumbs">
      <ul>
        <% items[0..-2].each do |item| %>
        <li><a href="<%= item.last %>"><%= item.first %></a></li> 
        
        <% end %>
        <li><%= items.last.first %></li>
      </ul>
    </div>
  ERB
end
