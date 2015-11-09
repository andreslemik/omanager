module ApplicationHelper
  def ficon(name, size = nil, *classes)
    add = classes.map(&:to_s).join(' ')
    content_tag(:i, nil, class: "fi-#{name} #{size} icon #{add}")
  end

  def nav_link(icon = nil, name = nil, options = nil, html_options = nil, &block)
    if block_given?
      html_options = options
      options = name
      name = block
    end
    options ||= {}
    html_options = convert_options_to_data_attributes(options, html_options)
    url = url_for(options)
    html_options['href'] ||= url
    pic = content_tag(:div, class: 'row') do
      content_tag(:div, class: 'columns text-center') do
        content_tag(:a, icon || url, html_options, &block)
      end
    end
    text = content_tag(:div, class: 'row') do
      content_tag(:div, class: 'columns text-center') do
        content_tag(:a, name || url, html_options, &block)
      end
    end
    content_tag :div, pic.concat(text), class: 'nav-group'
  end
end
