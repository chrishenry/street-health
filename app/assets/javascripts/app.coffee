receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
  'ngMap',
])

receta.config([ '$routeProvider',
  ($routeProvider)->

    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'MapController'
      )
])

