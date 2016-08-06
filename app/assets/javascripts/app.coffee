receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
  'uiGmapgoogle-maps',
])

receta.config([ '$routeProvider',
  ($routeProvider)->

    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'MapController'
      )
])

