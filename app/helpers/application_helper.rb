module ApplicationHelper

  def host_url
    'http://10.0.2.2:3000'
  end

  def full_name(user)
    user.first_name + ' ' + user.last_name
  end
end
