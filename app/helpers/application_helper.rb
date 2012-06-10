require 'menu'
include ActionView::Helpers::TextHelper

module ApplicationHelper
  def errors_for record
    render :partial => 'shared/form_errors', locals: { record: record }
  end

  def title(title)
    content_for(:title) { title }
  end

  def menu(request, &block)
    m = Menu.create(self)
    yield(m) 
    raw m.render(request.parameters, current_account)
  end

  def guarded_link_to(what, url_options)
    return '' unless ActionGuard.authorized?(current_account, url_options.stringify_keys)
    link_to(what, url_options)
  end

  def flash_tags
    raw(flash.collect do |name, message| 
      flash[name] = nil
      self.send("#{name}_flash_tag", message) if message
    end.join)
  end

  def presenter_name(presenter)
    presenter && presenter.name || "nobody"
  end

  private
  def alert_flash_tag(message)
    flash_tag(:alert, message)
  end

  def notice_flash_tag(message)
    flash_tag(:notice, message) + raw(%Q{
      <script type="text/javascript">
        $('#notice').delay(10000).fadeOut('slow');
      </script>
    })
  end

  def flash_tag(name, message)
    content_tag :div, message, :id => "#{name}", :class => "flash"
  end

  def wikinize( text )
    return "" unless text and not text.empty?
    if not text.index(/^\* /).nil?  #list
      text = text.gsub(/^\* (.*)/, '<li>\1</li>')
      text = text.gsub( /<\/li>\n<li>/, '<LIMIDDLELI>' ).gsub( /<li>/, '<ul><li>').gsub( /<\/li>/, '</li></ul>' )
      text = text.gsub( /<LIMIDDLELI>/, '</li><li>' )
    end
    text = text.gsub( /\*([^*\n]*)\*/, '<b>\1</b>' ) #bold
    text = text.gsub( /_([^_\n]*)_/, '<i>\1</i>' )   #italic
    text = text.gsub(/(http:\/\/[^ ]*)/, '<a href="\1">\1</a>') #links
    simple_format( text )
  end
  

end
