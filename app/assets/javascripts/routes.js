angular.module('mdme')
  .config(['$stateProvider', '$urlRouterProvider', 'AccessLevels', function($stateProvider, $urlRouterProvider, AccessLevels) {

    $stateProvider
      .state('anon', {
        abstract: true,
        templateUrl: "static_pages/_menu.html",
        data: {
          access: AccessLevels.anon
        }
      })
      .state('anon.home', {
        url: '/',
        templateUrl: 'static_pages/index.html',
        controller: 'StaticPagesController'
      })
      .state('anon.about', {
        url: '/about',
        templateUrl: 'static_pages/about.html',
        controller: 'StaticPagesController'
      })
      .state('anon.contact', {
        url: '/contact',
        templateUrl: 'static_pages/contact.html',
        controller: 'ContactController'
      })
      .state('anon.signin', {
        url: '/signin',
        templateUrl: 'static_pages/signin.html',
        controller: 'SessionsController'
      });

    $stateProvider
      .state('user', {
        abstract: true,
        templateUrl: 'patients/_menu.html',
        data: {
          access: AccessLevels.user
        }
      })
      .state('user.home', {
        url: '/patients',
        templateUrl: 'patients/show.html',
        controller:  'PatientsController'
      })
      .state('user.edit', {
        url: '/patients/:patientId/edit',
        templateUrl: 'patients/edit.html',
        controller: 'PatientsController'
      })
      .state('user.changePassword', {
        url: '/patients/:patientId/change-password',
        templateUrl: 'patients/change_password.html',
        controller: 'PatientsController'
      })
      .state('user.appointments', {
        url: '/patients/:patientId/appointments',
        templateUrl: 'patients/appointments/index.html',
        controller: 'PatientsAppointmentsController'
      })
      .state('user.newAppointment', {
        url: '/patients/:patientId/appointments/new',
        templateUrl: 'patients/appointments/new.html',
        controller: 'PatientsAppointmentController'
      })
      .state('user.appointment', {
        url: '/patients/:patientId/appointments/{appointmentId:[0-9]+}',
        templateUrl: 'patients/appointments/show.html',
        controller :'PatientsAppointmentController'
      })
      .state('user.openRequests', {
        url: '/patients/:patientId/appointments/requests',
        templateUrl: 'patients/appointments/requests.html',
        controller: 'PatientsAppointmentsController'
      })
      .state('user.clinics', {
        url: '/patients/:patientId/clinics',
        templateUrl: 'patients/clinics/index.html',
        controller: 'PatientsClinicsController'
      })
      .state('user.clinicShow', {
        url: '/patients/:patientId/clinics/:clinicId',
        templateUrl: 'patients/clinics/_show.html',
        controller: 'PatientsClinicController',
        parent: 'user.clinics'
      });

    $urlRouterProvider.otherwise('/');
  }]);