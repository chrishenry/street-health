controllers = angular.module('controllers', ['ngMap'])
controllers.controller("MapController",
  ['$scope', '$routeParams', '$resource', '$location', 'NgMap', 'flash', 'geolocation',
  ($scope,$routeParams,$resource,$location, NgMap,flash,geolocation)->
    Address = $resource('/addresses', { addressString: "@address", format: 'json' })

    if $routeParams.address
      $scope.address = $routeParams.address
      Address.query(address: $routeParams.address, (results)-> $scope.address_results = results)
    else
      $scope.address = null

    $scope.search = (address)->
      $location.path("/").search('address',address)

    NgMap.getMap().then((map)->
      console.log("HERERR");
      console.log(map.getCenter());
      console.log('markers', map.markers);
      console.log('shapes', map.shapes);
    );

])
