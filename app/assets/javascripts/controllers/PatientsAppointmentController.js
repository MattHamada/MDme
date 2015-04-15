app.controller('PatientsAppointmentController', ['$scope', '$location', '$state', '$stateParams', '$http', 'AuthInterceptor', 'flare', function($scope, $location, $state, $stateParams, $http, AuthInterceptor, flare) {
  $scope.patient = { id: $stateParams.patientId };
  $scope.appointment = {};
  $scope.doctor = {};
  $scope.clinics = {};
  $scope.doctors = {};
  $scope.times1 = [];
  $scope.times2 = [];
  $scope.selectedIndex = -1;
  var times = [];


  if ($state.current.name == 'user.appointment') {
    var req = {
      method: 'GET',
      url: '/patients/' + $stateParams.patientId + '/appointments/' + $stateParams.appointmentId + '.json',
      headers: $http.defaults.headers.common
    };
    req = AuthInterceptor.request(req);
    $http(req)
      .success(function(data) {
        $scope.appointment = data.appointment;
        $scope.doctor = data.doctor;
      })
      .error(function(err) {
        console.log(err);
      });
  }

  if ($state.current.name == 'user.newAppointment') {
    var reqClinics = {
      method: 'GET',
      url: '/patients/' + $stateParams.patientId + '/clinics.json',
      headers: $http.defaults.headers.common
    };
    reqClinics = AuthInterceptor.request(reqClinics);
    $http(reqClinics)
      .success(function(data) {
        $scope.clinics = data.clinics;
      })
      .error(function(err) {
        console.log(err);
      });
  }

  $scope.cancel = function() {
    var check = confirm('Are you sure you want to delete this appointment?');
    if (check == true) {
      var req = {
        method: 'delete',
        url: '/patients/' + $stateParams.patientId + '/appointments/' + $stateParams.appointmentId + '.json',
        headers: $http.defaults.headers.common
      };
      req = AuthInterceptor.request(req);
      $http(req)
        .success(function(data) {
          flare.success(data.status, 10000);
          $state.go('user.appointments', {patientId: $scope.patient.id});
        })
        .error(function(error) {
          console.log(error);
          flare.error('Error processing request, please try again', 10000);
          $state.go('user.appointments', {patientId: $scope.patient.id});
        });
    }
  };

  $scope.loadDoctors = function(clinic) {
    console.log(clinic);
    var docReq = {
      method: 'GET',
      url: '/patients/' + $stateParams.patientId + '/clinics/get-doctors.json?id=' + clinic.id,
      headers: $http.defaults.headers.common
    };
    docReq = AuthInterceptor.request(docReq);
    $http(docReq)
      .success(function(data) {
        console.log(data);
        $scope.doctors = data.doctors;
      })
      .error(function(err) {
        console.log(err);
      });
    console.log(clinic);
  };

  $scope.loadTimes = function(doctor) {
    //TODO make real api call
    var timeReq = {
      method: 'GET',
      params:  {
        date: $scope.appointment.date,
        doctor_id: $scope.appointment.doctor.id,
        clinic_id: $scope.appointment.clinic.id
      },
      url: '/doctors/opentimes.json',
      headers: $http.defaults.headers.common
    };
    timeReq = AuthInterceptor.request(timeReq);
    $http(timeReq)
      .success(function(data) {
        if (data.status == 0) { //success
          times = data.times;
          setTimeVars(times);
        } else if (data.status == 1) {
          flare.error(data.error, 10000);
        }

      })
      .error(function(err) {
        console.log(err);
      });
  };

  $scope.getTimeClass = function(time) {
    if (!time.enabled) {
      return 'list-group-item-danger';
    } else {
      if (time.selected) {
        return 'list-group-item-success';
      } else {
        return 'list-group-item-warning';
      }
    }
  };

  $scope.selectTime = function(time) {
    if (time.enabled) {
      for (var j = 0; j < times.length; j++) {
        times[j].selected = false;
      }
      times[time.index].selected = true;
      $scope.appointment.time = times[time.index].time;
      setTimeVars(times);
    }
  };
  var setTimeVars = function(times) {
    $scope.times1 = [];
    $scope.times2 = [];
    var length = times.length;
    var half = Math.floor(length / 2);
    var split = 0;
    if (length % 2 == 0) {
      split = length - half;
    } else {
      split = length - half - 1;
    }
    for (var i = 0; i < half; i++) {
      $scope.times1.push(times[i]);
    }
    for(var i = split; i< length; i++) {
      $scope.times2.push(times[i]);
    }
    console.log($scope.times1);
    console.log($scope.times2);

  };

  $scope.createAppointment = function() {
    var newApptReq = {
      method: 'POST',
      data: {
        'appointment': {
          'doctor_id': $scope.appointment.doctor.id,
          'date': $scope.appointment.date,
          'time': $scope.appointment.time,
          'inform_earlier_time': $scope.appointment.notify_earlier,
          'description':  $scope.appointment.description,
          'clinic_id': $scope.appointment.clinic.id
        }
      },
      url: '/patients/' + $stateParams.id  + '/appointments',
      headers: $http.defaults.headers.post
    };
    newApptReq = AuthInterceptor.request(newApptReq);
    $http(newApptReq)
      .success(function(data) {
        $state.go('user.appointments', {patientId: $stateParams.patientId});
        flare.success('Appointment requested', 10000);
      })
      .error(function(data) {
        flare.error(data.error, 10000);
      })
  };
}]);