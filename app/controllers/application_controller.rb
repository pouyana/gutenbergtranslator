class ApplicationController < ActionController::Base
helper :all
#this part is taken from ror i18l manual here:
#http://guides.rubyonrails.org/i18n.html
#and http://ruby-auf-schienen.de/3.2/i18n_mehrsprachige_rails_applikation.html
  def self.default_url_options
    { :locale => I18n.locale }
  end
  before_filter :set_locale
  def set_locale
   I18n.locale = params[:locale] || I18n.default_locale
   Rails.application.routes.default_url_options[:locale]= I18n.locale 
  end
  helper :all
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
end

