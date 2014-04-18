module ApplicationHelper

  #Set to http://10.0.2.2:3000 for android emulator
  #set to http://www.lvh.me:3000 for browser
  #set to http://www.mdme.us for production
  def host_url
    'http://www.lvh.me:3000'
  end

  def full_name(user)
    user.first_name + ' ' + user.last_name
  end
end
