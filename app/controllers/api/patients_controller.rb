module Api

  class PatientsController < RocketPants::Base
    version 1

    caches :show, :caches_for => 5.minutes

    def show
      expose Patient.find(params[:id]).appointments
    end
  end

end