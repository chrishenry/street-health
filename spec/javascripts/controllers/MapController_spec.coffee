describe "MapController", ->
  scope        = null
  ctrl         = null
  routeParams  = null
  httpBackend  = null
  flash        = null
  location     = null

  fakeAddress =
    id: 1
    address: '324 SPRING STREET'
    latitude: 40.7258383
    longitude: -74.0094194
    service_requests: []

  setupController =(addressExists=true,address=null)->
    inject(($location, $routeParams, $rootScope, $httpBackend, $controller, _flash_)->
      scope       = $rootScope.$new()
      location    = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.address = address if address
      flash = _flash_

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

    describe 'address is found', ->
      it 'loads the given address', ->
        input = "324 Spring St"
        setupController(true, input)
        httpBackend.flush()
        expect(scope.address).toEqualData(input)

  # describe 'recipe is not found', ->
  #   beforeEach(setupController(false))
  #   it 'loads the given recipe', ->
  #     httpBackend.flush()
  #     expect(scope.recipe).toBe(null)
  #     expect(flash.error).toBe("There is no recipe with ID #{recipeId}")
