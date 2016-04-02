receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
  'uiGmapgoogle-maps',
  'angular-flash.service',
  'angular-flash.flash-alert-directive'
])

receta.config([ '$routeProvider', 'flashProvider',
  ($routeProvider,flashProvider)->

    flashProvider.errorClassnames.push("alert-danger")
    flashProvider.warnClassnames.push("alert-warning")
    flashProvider.infoClassnames.push("alert-info")
    flashProvider.successClassnames.push("alert-success")

    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'MapController'
      ).when('/address/new',
        templateUrl: "form.html",
        controller: 'MapController'
      ).when('/address/:addressId',
        templateUrl: "show.html"
        controller: 'MapController'
      ).when('/address/:addressId/edit',
        templateUrl: "form.html",
        controller: 'MapController'
      )
])

controllers = angular.module('controllers',[])

