describe "MapController", ->
  scope        = null
  ctrl         = null
  routeParams  = null
  httpBackend  = null
  flash        = null
  location     = null

  fakeAddress   =
    address: '324 Spring St'

  setupController =(addressExists=true,address=null)->
    inject(($location, $routeParams, $rootScope, $httpBackend, $controller, _flash_)->
      scope       = $rootScope.$new()
      location    = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.address = encodeURIComponent(address) if address
      flash = _flash_

      if address
        request = new RegExp("\/addresses?address=#{address}*")
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
      beforeEach(setupController())
      it 'has scope of null', ->
        expect(scope.address).toEqualData(null)

    # describe 'address is found', ->
    #   beforeEach(setupController(true, "324 Spring St"))
    #   it 'loads the given address', ->
    #     httpBackend.flush()
    #     expect(scope.address).toEqualData(fakeAddress)

  # describe 'recipe is not found', ->
  #   beforeEach(setupController(false))
  #   it 'loads the given recipe', ->
  #     httpBackend.flush()
  #     expect(scope.recipe).toBe(null)
  #     expect(flash.error).toBe("There is no recipe with ID #{recipeId}")
