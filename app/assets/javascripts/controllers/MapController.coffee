controllers = angular.module('controllers')
controllers.controller("MapController", [ '$scope', '$routeParams', '$resource', '$location', 'flash',
  ($scope,$routeParams,$resource,$location, flash)->

    $scope.map = { center: { latitude: 45, longitude: -73 }, zoom: 8 };

])
