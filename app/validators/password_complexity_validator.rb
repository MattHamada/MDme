class PasswordComplexityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message]  || 'must include at least one lowercase letter, one uppercase letter, and one digit') unless value =~ /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$/
  end
end