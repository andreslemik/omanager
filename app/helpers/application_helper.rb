module ApplicationHelper
  def ficon(name, size = nil)
    content_tag(:i, nil, class: "fi-#{name} #{size} icon")
  end
end
