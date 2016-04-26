controllers = angular.module('controllers', ['ngMap'])
controllers.controller("MapController",
  ['$scope', '$routeParams',  '$location', '$http', '$resource', '$interval', 'NgMap',
  ($scope, $routeParams, $location, $http, $resource, $interval, NgMap)->
    Address = $resource('/addresses/show.json', { addressString: "@address" })

    $scope.positions = [];

    # generateMarkers = ()->
    #   $scope.positions = [];
    #   numMarkers = Math.floor(Math.random() * 4) + 4;
    #   for i in [0...numMarkers]
    #     lat = 40.7128 + (Math.random() / 100);
    #     lng = -74.0059 + (Math.random() / 100);
    #     $scope.positions.push({pos:[lat,lng]});

    #   console.log("$scope.positions", $scope.positions);

    # $interval(generateMarkers, 2000);


    if $routeParams.address
      $scope.address = $routeParams.address
      $http({
        url: '/addresses/show.json?address=' + $routeParams.address,
        method: 'GET'
      }).then((response)->
        console.log(response.data)

        pos = {pos: [response.data.latitude, response.data.longitude]}
        console.log(pos)
        $scope.positions.push(pos)

      )


      # address = Address.get(address: $routeParams.address, isArray: false, (address)->

      #   pos = {pos: [address.latitude, address.longitude]}

      #   console.log(pos)
      #   console.log($scope)

      #   $scope.positions.push(pos)

      #   console.log($scope.positions)

      # )

    $scope.search = (address)->
      $location.path("/").search('address',address)

])
