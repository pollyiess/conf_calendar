class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    root_path
  end

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
