module ApplicationHelper
  def switch_locale_url(locale)
    path = request.path

    if path.match?(%r{\A/(ru|en)/users/password\z})
      return "/#{locale}/users/password/new"
    end

    if path.match?(%r{\A/(ru|en)/users\z})
      return "/#{locale}/users/sign_up"
    end

    if path.match?(%r{\A/(ru|en)(/|$)})
      path.sub(%r{\A/(ru|en)}, "/#{locale}")
    else
      "/#{locale}#{path}"
    end
  end
end
