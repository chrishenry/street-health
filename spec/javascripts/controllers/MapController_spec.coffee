describe "MapController", ->
  scope        = null
  ctrl         = null
  routeParams  = null
  httpBackend  = null
  location     = null

  fakeAddress =
    id: 1
    address: '324 SPRING STREET'
    latitude: 40.7258383
    longitude: -74.0094194
    service_requests: [
      {
        complaint_type: "Noise - Commercial",
        created_date: "2012-02-18T00:10:16.000Z",
        descriptor: "Loud Music/Party",
      }
    ]

  setupController =(addressExists=true,address=null)->
    inject(($location, $routeParams, $rootScope, $httpBackend, $controller)->
      scope       = $rootScope.$new()
      location    = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.address = address if address

      if address
        request = new RegExp("\/addresses*")
        results = if addressExists
          [200,fakeAddress]
        else
          [404]

        httpBackend.expectGET(request).respond(results[0],results[1])

      ctrl = $controller('MapController',
                          $scope: scope)
    )

  beforeEach(module("receta"))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->
    describe 'no address provided', ->
      it 'has scope of null', ->
        setupController()
        expect(scope.address_results).toEqualData(undefined)
        expect(scope.markers.length).toEqualData(0)

    describe 'address is found', ->
      it 'loads the address and updates the UI', ->
        input = "324 Spring St"
        setupController(true, input)
        httpBackend.flush()
        expect(scope.address).toEqualData(input)

        # Map changes
        expect(scope.markers.length).toEqualData(1)
        expect(scope.map.zoom).toEqualData(18)
        expect(scope.service_requests.length).toEqualData(1)
        expect(scope.complaint_types.length).toEqualData(1)
