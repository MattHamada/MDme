module FactoryHelpers
  def create_time
    date = (DateTime.now + 3.days).change({hour: 11, minute: 15})
  end

  def create_time_today
    date = (DateTime.now + 1.hour).change({minute: 15})
  end
end

FactoryGirl::SyntaxRunner.send(:include, FactoryHelpers)