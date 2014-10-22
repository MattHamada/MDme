# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 2/21/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +EmailFormatValidator+ verifies the email addresses entered
# is in a valid email address format
class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (
        options[:message]  || 'is not a valid email address') unless
            value =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  end
end