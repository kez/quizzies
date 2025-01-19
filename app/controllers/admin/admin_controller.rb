class Admin::AdminController < ApplicationController
  before_action :require_admin

  def index
    @title = "Admin"
  end

  private

  def require_admin
    redirect_to root_url unless authenticated? && Current.user.admin?
  end

  private

  def set_breadcrumbs
    super
    @breadcrumbs << ["Admin", admin_root_url]
  end
end
