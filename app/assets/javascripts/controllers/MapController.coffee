controllers = angular.module('controllers', ['uiGmapgoogle-maps'])
controllers.controller("MapController",
  ['$scope', '$routeParams',  '$location', '$http', '$resource', '$interval', 'flash',
  ($scope, $routeParams, $location, $http, $resource, $interval, flash)->
    Address = $resource('/addresses/show.json', { addressString: "@address" })

    $scope.positions = [];

    $scope.map = {
      center: {
        latitude: 40.7128,
        longitude: -74.0059
      },
      zoom: 13
    };
    $scope.markers = []
    $scope.service_requests = []

    if $routeParams.address
      $scope.address = $routeParams.address
      $http({
        url: '/addresses/show.json?address=' + $routeParams.address,
        method: 'GET'
      }).then((response)->
        console.log(response.data)

        $scope.markers.push({
          id: 0,
          coords: {
            latitude: response.data.latitude,
            longitude: response.data.longitude
          },
          options: { draggable: false },
          events: {}
        });

        $scope.map.center = {
          latitude: response.data.latitude,
          longitude: response.data.longitude
        }
        $scope.map.zoom = 18
        $scope.service_requests = response.data.service_requests

        $scope.complaint_types = requestTypeCount(response.data.service_requests)

      )

    $scope.search = (address)->
      $location.path("/").search('address',address)

    requestTypeCount = (data)->

      retval = {}

      for i in [0...data.length]
        ct = data[i].complaint_type
        if ct of retval
          retval[ct].count++
        else
          retval[ct] = {type: ct, count: 1}

      log = [];
      angular.forEach(retval, (value, key)->
        this.push(value);
      , log);

      console.log(retval)
      console.log(log)

      return log

])
