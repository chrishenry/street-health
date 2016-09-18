// Generated by CoffeeScript 1.10.0
(function() {
  var controllers;

  controllers = angular.module('controllers', ['uiGmapgoogle-maps', 'ui.bootstrap', 'ngFlash', 'bsLoadingOverlay']);

  controllers.controller("MapController", [
    '$scope', '$routeParams', '$location', '$http', '$resource', '$interval', 'Flash', 'bsLoadingOverlayService',
    function($scope, $routeParams, $location, $http, $resource, $interval, Flash, bsLoadingOverlayService) {

      var requestTypeCount;

      $scope.positions = [];
      $scope.map = {
        center: {
          latitude: 40.7128,
          longitude: -74.0059
        },
        zoom: 13
      };
      $scope.markers = [];
      $scope.service_requests = false;

      var addressHandler = function(response) {
        if(response.data.error) {
          $scope.flash = Flash.create('success', response.data.error, 0, {class: 'alert alert-danger'}, true);
        } else {
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
          if(response.data.service_requests && response.data.service_requests.length > 0) {
            $scope.service_requests = response.data.service_requests;
            $scope.complaint_types = requestTypeCount(response.data.service_requests);
          } else {
            $scope.service_requests = [];
          }
          Flash.clear();
        }
      };

      var addressErrorHandler = function(response) {
        $scope.flash = Flash.create('success', "Uh-oh, something went wrong...", 0, {class: 'alert alert-danger'}, true);
      };

      if ($routeParams.address) {
        $scope.address = $routeParams.address;
        $http({
          url: '/addresses/show.json?address=' + $routeParams.address,
          method: 'GET'
        }).then(addressHandler, addressErrorHandler);
      }

      $scope.search = function(address) {
        return $location.path("/").search('address', address);
      };

      requestTypeCount = function(service_requests) {
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
        return log;
      };

    }
  ]);

}).call(this);
