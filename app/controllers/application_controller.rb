class ApplicationController < ActionController::Base
  def self.default_url_options
    { :locale => I18n.locale }
  end
#  before_filter :set_locale
#  def set_locale
#   I18n.locale = params[:locale] || I18n.default_locale
#  end
  helper :all
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
end

