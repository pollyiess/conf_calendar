class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # После входа возвращаем человека туда, куда он шёл (форма создания, страница конференции).
  # Если он просто нажал «Войти», то на главную.
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  # После выхода ведём на страницу входа
  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end
