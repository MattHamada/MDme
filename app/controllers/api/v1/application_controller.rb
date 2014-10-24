# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/23/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.


# +Api::V1::ApplicationController+ adjusts protect_from_forgery settings
# to suggested :with => :null_session for APIs.  Used as a base controller for
# all other API::V1 controllers
class Api::V1::ApplicationController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

end

