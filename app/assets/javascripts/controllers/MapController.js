// Generated by CoffeeScript 1.10.0
(function() {
  var controllers;

  controllers = angular.module('controllers', ['uiGmapgoogle-maps', 'ui.bootstrap']);

  controllers.controller("MapController", [
    '$scope', '$routeParams', '$location', '$http', '$resource', '$interval', function($scope, $routeParams, $location, $http, $resource, $interval) {
      var Address, requestTypeCount;
      Address = $resource('/addresses/show.json', {
        addressString: "@address"
      });
      $scope.positions = [];
      $scope.map = {
        center: {
          latitude: 40.7128,
          longitude: -74.0059
        },
        zoom: 13
      };
      $scope.markers = [];
      $scope.service_requests = [];
      if ($routeParams.address) {
        $scope.address = $routeParams.address;
        $http({
          url: '/addresses/show.json?address=' + $routeParams.address,
          method: 'GET'
        }).then(function(response) {
          console.log(response.data);
          $scope.markers.push({
            id: 0,
            coords: {
              latitude: response.data.latitude,
              longitude: response.data.longitude
            },
            options: {
              draggable: false
            },
            events: {}
          });
          $scope.map.center = {
            latitude: response.data.latitude,
            longitude: response.data.longitude
          };
          $scope.map.zoom = 18;
          $scope.service_requests = response.data.service_requests;
          return $scope.complaint_types = requestTypeCount(response.data.service_requests);
        });
      }
      $scope.search = function(address) {
        return $location.path("/").search('address', address);
      };
      return requestTypeCount = function(service_requests) {
        var ct, i, j, log, ref, retval;
        retval = {};
        for (i = j = 0, ref = service_requests.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
          ct = service_requests[i].complaint_type;
          if (ct in retval) {
            retval[ct].count++;
          } else {
            retval[ct] = {
              type: ct,
              count: 1
            };
          }
        }
        log = [];
        angular.forEach(retval, function(value, key) {
          return this.push(value);
        }, log);
        console.log(retval);
        console.log(log);
        return log;
      };
    }
  ]);

}).call(this);