controllers = angular.module('controllers')
controllers.controller("MapController", [ '$scope', '$routeParams', '$resource', '$location', 'flash', 'geolocation',
  ($scope,$routeParams,$resource,$location, flash,geolocation)->

    $scope.map = { center: { latitude: 40.7128, longitude: -74.0059 }, zoom: 12 }

    geolocation.getLocation().then (data) ->
      $scope.coords =
        lat: data.coords.latitude
        long: data.coords.longitude
      $scope.map.center = { latitude: data.coords.latitude, longitude: data.coords.longitude }
      $scope.map.zoom = 18
      return

])
