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
    Currency.find session[:currency]
  rescue ActiveRecord::RecordNotFound
    logger.error "Invalid currency #{session[:currency]}"
    nil
  end

  def static_url(url)
    STATIC_ROOT_URL + url
  end
end
