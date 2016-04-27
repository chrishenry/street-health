controllers = angular.module('controllers', ['uiGmapgoogle-maps'])
controllers.controller("MapController",
  ['$scope', '$routeParams',  '$location', '$http', '$resource', '$interval', 'flash',
  ($scope, $routeParams, $location, $http, $resource, $interval, flash)->
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

    $scope.map = {
      center: {
        latitude: 40.7128,
        longitude: -74.0059
      },
      zoom: 13
    };
    $scope.markers = []

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

        $scope.markers.push({
          id: 0,
          coords: {
            latitude: response.data.latitude,
            longitude: response.data.longitude
          },
          options: { draggable: true },
          events: {
            dragend: (marker, eventName, args)->
              $log.log('marker dragend');
              lat = marker.getPosition().lat();
              lon = marker.getPosition().lng();
              $log.log(lat);
              $log.log(lon);

              $scope.marker.options = {
                draggable: true,
                labelContent: "lat: " + $scope.marker.coords.latitude + ' ' + 'lon: ' + $scope.marker.coords.longitude,
                labelAnchor: "100 0",
                labelClass: "marker-labels"
              };
          }
        });

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
