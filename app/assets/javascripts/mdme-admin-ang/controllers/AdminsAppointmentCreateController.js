angular.module('mdme-admin').controller('AdminsAppointmentCreateController', ['$scope', 'flare', '$http', '$state', '$stateParams', 'AdminAuthInterceptor', 'AdminLocalService', function($scope, flare, $http, $state, $stateParams, AdminAuthInterceptor, AdminLocalService) {
  $scope.times1 = [];
  $scope.times2 = [];
  $scope.selectedIndex = -1;
  $scope.appointment = {description: ' ', inform_earlier_time: false}; //need to define here incase left blank on form
  var dateChange = false;
  var doctorChange = false;
  var times = [];

  $scope.dateChosen = function() {
    dateChange = true;
  };

  $scope.doctorChosen = function() {
    doctorChange = true;
  };

  //load doctor select
  var reqDoctors = {
    method: 'GET',
    url: '/clinics/' + AdminLocalService.get('clinicId') + '/doctors.json',
    headers: $http.defaults.headers.common
  };
  reqDoctors = AdminAuthInterceptor.request(reqDoctors);
  $http(reqDoctors)
    .success(function(data) {
      $scope.doctors = data.doctors;
    })
    .error(function(err) {
      console.log(err);
    });

  //load patient select
  var reqPatients = {
    method: 'GET',
    url: '/admins/' + $stateParams.adminId + '/patients.json',
    headers: $http.defaults.headers.common
  };
  reqPatients = AdminAuthInterceptor.request(reqPatients);
  $http(reqPatients)
    .success(function(data) {
      $scope.patients = data.patients;
    })
    .error(function(err) {
      console.log(err);
    });

  $scope.loadTimes = function() {
    //if (dateChange && doctorChange) {
      var timeReq = {
        method: 'GET',
        params:  {
          date: $scope.appointment.date,
          doctor_id: $scope.appointment.doctor.id,
          clinic_id: AdminLocalService.get('clinicId')
        },
        url: '/clinics/' + AdminLocalService.get('clinicId') + '/doctors/opentimes.json',
        headers: $http.defaults.headers.common
      };
      timeReq = AdminAuthInterceptor.request(timeReq);
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
    //}
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
          'patient_id': $scope.appointment.patient.id
        }
      },
      url: '/admins/' + $stateParams.id  + '/appointments',
      headers: $http.defaults.headers.post
    };
    newApptReq = AdminAuthInterceptor.request(newApptReq);
    $http(newApptReq)
      .success(function(data) {
        $state.go('admin.appointments', {adminId: $stateParams.adminId});
        flare.success(data.status, 10000);
      })
      .error(function(err) {
        for (var e in err.errors) {
          flare.error(err.errors[e], 10000);
        }
      })
  };

}]);