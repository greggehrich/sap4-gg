$(function(){
  GoogleMapSearch.init();
});

var GoogleMapSearch = function(){

  var currentLat, currentLng;

  var bluePin = 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png';
  var greenPin = 'http://maps.google.com/mapfiles/ms/icons/green-dot.png';
  var redPin = 'http://maps.google.com/mapfiles/ms/icons/red-dot.png';
  var yellowPin = 'http://maps.google.com/mapfiles/ms/icons/yellow-dot.png';
  var purplePin = 'http://maps.google.com/mapfiles/ms/icons/purple-dot.png';
  var whitePin = '/assets/white-map-pin.png';
  var currentLocationPin = 'http://maps.google.com/mapfiles/kml/pal4/icon58.png';

  var initializeMap = function(){
    var mapDiv = _getMapDiv();
    if(navigator.geolocation){
  		navigator.geolocation.getCurrentPosition(
        function(position){
          currentLat = position.coords.latitude;
          currentLng = position.coords.longitude;
          var map = _getGoogleMap(currentLat, currentLng);
          google.maps.event.addListener(map, 'idle', function(){
            drawMap(map);
          });
        },
        function(error){// it's possible that the user is not allowing geolocation, even though it's available
          mapDefaultUserZipCode();
        }
      );
    }
  	else {// gelocation is not available
      mapDefaultUserZipCode();
    }
  }

  var drawMapFromAddress = function(address){
    _showLoadingDiv();
    var myForm = $(this);
    var address = myForm.find('input[name=search]').val();
    if(address){
      geocoder = new google.maps.Geocoder();
      geocoder.geocode({'address': address}, function(results, status){
        var lat = results[0].geometry.location.lat();
        var lng = results[0].geometry.location.lng();
        var map = _getGoogleMap(lat, lng);
        google.maps.event.addListener(map, 'idle', function(){
          drawMap(map);
        });
      });
    }
    else {
      initializeMap();
    }
  }

  var drawMap = function(map){
    if(_getMapDiv().attr('all-places') == 'true'){
      findAndDrawAllPlaces(map);
    }
    else {
      findAndDrawFavoritePlaces(map);
    }
    _hideLoadingDiv();
  }

  var findAndDrawFavoritePlaces = function(map){
    _setCurrentLocationPin(map)
    var favePlaces = JSON.parse($('#favorite_places_json').html());
    $(favePlaces).each(function(idx, place){
      var latLng = new google.maps.LatLng(place.lat, place.lng);
      if(map.getBounds().contains(latLng)){
        var marker = new google.maps.Marker({
          position: latLng,
          map: map,
          title: place.name,
          icon: _choosePinColor(place.base_category)
        });
      }
    });
  }

  // only accessible with search text
  var findAndDrawAllPlaces = function(map){
    var locationText = $('input[name="search"]').val();
    $.ajax({
      url: '/map/all_nearby_places.json',
      method: 'GET',
      data: {location_text: locationText}
    }).done(function(data){
      _setCurrentLocationPin(map);
      $(data).each(function(idx, place){
        var latLng = new google.maps.LatLng(place.lat, place.lng);
        if(map.getBounds().contains(latLng)){
          var marker = new google.maps.Marker({
            position: latLng,
            map: map,
            title: place.name,
            icon: _choosePinColor(place.base_category)
          });
        }
      });
    });
  }

  var toggleAllOrFavoritePlaces = function(){
    var myInput = $(this);
    var mapDiv = _getMapDiv();
    if(myInput.val() == 'all_places'){
      mapDiv.attr('all-places', 'true');
    }
    else {
      mapDiv.removeAttr('all-places');
    }
  }

  var enableAllPlaces = function(){
    var myInput = $(this);
    if(myInput.val().length > 0){
      var allPlacesRadioButton = $('#all_places_radio_btn');
      allPlacesRadioButton.removeAttr('disabled');
      allPlacesRadioButton.siblings('span').removeClass('text-muted');
    }
  }

  var disableAllPlaces = function(){
    var myInput = $(this);
    if(myInput.val().length < 1){
      var allPlacesRadioButton = $('#all_places_radio_btn');
      allPlacesRadioButton.attr('disabled', true)
      allPlacesRadioButton.prop('checked', false);
      allPlacesRadioButton.siblings('span').addClass('text-muted');
      _getMapDiv().removeAttr('all-places');
    }
  }

  // var drawUsMap = function(map){
  //   if(_getMapDiv().attr('all-places') != 'true'){
  //     drawUsMapWithFavoritePlaces(map);
  //   }
  //   _hideLoadingDiv();
  // }

  // var drawUsMapWithFavoritePlaces = function(map){
  //   var favePlaces = JSON.parse($('#favorite_places_json').html());
  //   $(favePlaces).each(function(idx, place){
  //     var latLng = new google.maps.LatLng(place.lat, place.lng);
  //     if(map.getBounds().contains(latLng)){
  //       var marker = new google.maps.Marker({
  //         position: latLng,
  //         map: map,
  //         title: place.name
  //       });
  //     }
  //   });
  // }

  var mapDefaultUserZipCode = function(){
    geocoder = new google.maps.Geocoder();
    geocoder.geocode({'address': _getUserZipcode()}, function(results, status){
      currentLat = results[0].geometry.location.lat();
      currentLng = results[0].geometry.location.lng();
      var map = _getGoogleMap(currentLat, currentLng);
      _setCurrentLocationPin(map);
      google.maps.event.addListener(map, 'idle', function(){
        drawMap(map);
        _hideLoadingDiv();
      });
    });
  }


  var _getUserZipcode = function(){
    return $('#map_container_div').attr('data-user-zip-code');
  }

  var _getGoogleMap = function(lat, lng, opts){
    var mapOptions = {
      zoom: 10,
      center: new google.maps.LatLng(lat, lng)
    }
    mapOptions = $.extend({}, mapOptions, opts || {});
    map = new google.maps.Map(_getMapDiv()[0], mapOptions);
    _setCurrentLocationPin(map);
    return map;
  }


  var _setCurrentLocationPin = function(map){
    if((typeof currentLat == 'undefined') || (typeof currentLng == 'undefined')){
      return;
    }
    var latLng = new google.maps.LatLng(currentLat, currentLng);
    var marker = new google.maps.Marker({
      position: latLng,
      map: map,
      title: 'Current Location',
      zIndex: 1000,
      icon: currentLocationPin
    });
  }

  var _choosePinColor = function(cat){
    if(cat == 'Food/Drink'){
      return greenPin;
    }
    else if(cat == 'Attraction'){
      return redPin;
    }
    else if(cat == 'Lodging'){
      return bluePin;
    }
    else {
      return whitePin;
    }
  }

  var _getEmptyUsMap = function(){
    var mapOptions = {
      zoom: 5,
      center: new google.maps.LatLng(37.09024, -95.712891)
    }
    map = new google.maps.Map(_getMapDiv()[0], mapOptions);
    return map;
  }

  var _getMapDiv = function(){
    return $('#map_canvas');
  }

  var _hideLoadingDiv = function(){
    $('.loading_div').hide();
  }

  var _showLoadingDiv = function(){
    $('.loading_div').show();
  }

  return {

    init:function(){
      initializeMap();
      $('input[name="search"]').on('keyup', enableAllPlaces);
      $('input[name="search"]').on('blur', disableAllPlaces);
      $('.map_search_form').on('submit', drawMapFromAddress);
      $('input[name=places_options]').on('click', toggleAllOrFavoritePlaces);
    }

  }

}();
