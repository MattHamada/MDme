class Admins::ApplicationController < ApplicationController
  layout "admin"
  before_filter :require_admin_login
end