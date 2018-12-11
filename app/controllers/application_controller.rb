class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def set_last_seen_at
    current_user.update_column(:last_seen_at, Time.now)
  end

end
