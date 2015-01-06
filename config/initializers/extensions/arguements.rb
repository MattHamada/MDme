#Monkeypatch of activejob to support serializing Date/Time for ActionMailer.deliver_later
#TODO move to a gem

module ActionMailer
  class DeliveryJob < ActiveJob::Base
    extend ActiveJob::Arguments
  end
end

module ActiveJob
  module Arguments
    TYPE_WHITELIST = [ Date, DateTime, Time, NilClass, Fixnum, Float, String, TrueClass, FalseClass, Bignum ]
  end
end


