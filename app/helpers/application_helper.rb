class Array
  def matrix_iterate(max_x)
    i = j = 0
    each do |value|
      yield value, i, j
      i = (i + 1) % max_x
      if i == 0
        j += 1
      end
    end
  end
end

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def logged_in
    session[:user] ? true : false
  end

  def admin?
    @user && @user.admin?
  end

  def all_currencies
    currencies = { }
    Currency.all.each do |currency|
      currencies[currency.description] = currency.id
    end
    currencies
  end

  def current_currency
    @currency
  end

  def static_url(url)
    STATIC_ROOT_URL + url
  end

  def nl2br(s)
    s.gsub(/\n/, '<br/>')
  end

  def copyright_time(from_year)
    this_year = DateTime.now.strftime('%Y')
    (this_year == from_year.to_s) ? from_year : "#{from_year}-#{this_year}"
  end

  def warning_box(id, params)
    content = "<div>#{params[:content]}</div>"
    signature = params[:signature] ? "<div class=\"warning_box_signature\">#{params[:signature]}</div>" : nil
    button = params[:button] ? "<div class=\"warning_box_button\">#{params[:button]}</div>" : nil 
    "<div class=\"warning_box\" id=\"#{id}\">
      <table>
        <tbody>
        <tr>
          <td>#{image_tag 'warning_utsuho.png', :width => 151, :height => 100, :alt => t('home.warning.title')}</td>
          <td>
            #{content}
            #{signature}
            #{button}
          </td>
        </tr>
        </tbody>
      </table>
    </div>"
  end
end
