module ApplicationHelper

  def ficon(icon, size=nil)
    "<i class='fi-#{icon} #{size}'></i>".html_safe
  end
end
