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

  def current_currency
    # TODO add other currencies support
    Currency.find 2 # Euro
  end
end
