# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 2/21/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +PasswordComplexityValidator+ verifies the password entered contains
# one number, one lowercase letter, and one uppercase letter

class PasswordComplexityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (
      options[:message]  || 'must include at least one lowercase letter,
      one uppercase letter, and one digit') unless
          value =~ /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$/
  end
end