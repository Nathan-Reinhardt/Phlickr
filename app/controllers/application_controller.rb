class ApplicationController < ActionController::Base
    helper_method :current_user, :required_login, :require_logout, :login!, :logged_in?, :logout!

    def current_user
        @current_user ||= User.find_by_session_token(session[:session_token])
    end

    def login!(user)
        session[:session_token] = user.session_token
    end

    def logged_in?
        !!current_user
    end

    def logout!
        current_user.reset_session_token
        session[:session_token] = nil
    end

    def required_login
        redirect_to new_session_url unless logged_in?
    end

    def require_logout
        redirect_to user_url(current_user) if logged_in?
    end
    
end
