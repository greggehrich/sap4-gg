$(function(){
  GoogleMapSearch.init();
});

var GoogleMapSearch = function(){

  var map, currentLat, currentLng;
  var currentMarkers = [];

  var bluePin = 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png';
  var greenPin = 'http://maps.google.com/mapfiles/ms/icons/green-dot.png';
  var redPin = 'http://maps.google.com/mapfiles/ms/icons/red-dot.png';
  var yellowPin = 'http://maps.google.com/mapfiles/ms/icons/yellow-dot.png';
  var purplePin = 'http://maps.google.com/mapfiles/ms/icons/purple-dot.png';
  var whitePin = '/assets/white-map-pin.png';
  var currentLocationPin = 'http://maps.google.com/mapfiles/kml/pal4/icon58.png';

  var initializeMap = function(){
    var mapDiv = _getMapDiv();
    if($('#search_map_container_div').length > 0) && navigator.geolocation){
  		navigator.geolocation.getCurrentPosition(
        function(position){
          currentLat = position.coords.latitude;
          currentLng = position.coords.longitude;
          map = _getGoogleMap(currentLat, currentLng);
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

  var drawMapFromSearch = function(address){
    _showLoadingDiv();
    _clearNearbyAllPlacesDataCache();
    var myForm = $(this);
    var address = myForm.find('input[name=search]').val();
    if(address){ // new map
      geocoder = new google.maps.Geocoder();
      geocoder.geocode({'address': address}, function(results, status){
        var lat = results[0].geometry.location.lat();
        var lng = results[0].geometry.location.lng();
        map = _getGoogleMap(lat, lng);
        google.maps.event.addListener(map, 'idle', function(){
          drawMap(map);
        });
      });
    }
    else {
      _clearAllMarkers(currentMarkers);
      drawMap(map);
      google.maps.event.addListener(map, 'idle', function(){
        drawMap(map);
      });
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
        currentMarkers.push(marker);
      }
    });
  }

  var findAndDrawAllPlaces = function(map){
    var latLng = map.getCenter();
    var locationCoordsText = latLng.lat() + ',' + latLng.lng();
    var nearbyAllPlacesElm = $('#nearby_all_places_json');
    if(nearbyAllPlacesElm.length > 0){
      _showLoadingPlacesDiv();
      var data = JSON.parse(nearbyAllPlacesElm.html());
      _setCurrentLocationPin(map);
      _drawNearybyAllPlacesPins(data, map);
      _hideLoadingPlacesDiv();
    }
    else {
      _showLoadingPlacesDiv();
      $.ajax({
        url: '/map/all_nearby_places.json',
        method: 'GET',
        data: {location_coords_text: locationCoordsText}
      }).done(function(data){
        _cacheNearbyAllPlacesData(data);
        _setCurrentLocationPin(map);
        _drawNearybyAllPlacesPins(data, map);
        _hideLoadingPlacesDiv();
      });
    }
  }

  var mapDefaultUserZipCode = function(){
    geocoder = new google.maps.Geocoder();
    geocoder.geocode({'address': _getUserZipcode()}, function(results, status){
      currentLat = results[0].geometry.location.lat();
      currentLng = results[0].geometry.location.lng();
      map = _getGoogleMap(currentLat, currentLng);
      _setCurrentLocationPin(map);
      google.maps.event.addListener(map, 'idle', function(){
        drawMap(map);
        _hideLoadingDiv();
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

  var _drawNearybyAllPlacesPins = function(data, map){
    $(data).each(function(idx, place){
      var latLng = new google.maps.LatLng(place.lat, place.lng);
      if(map.getBounds().contains(latLng)){
        var marker = new google.maps.Marker({
          position: latLng,
          map: map,
          title: place.name,
          icon: _choosePinColor(place.base_category)
        });
        currentMarkers.push(marker);
      }
    });
  }

  var _clearAllMarkers = function(){
    $.each(currentMarkers, function(idx, marker){
      marker.setMap(null);
    });
    currentMarkers = [];
  }

  var _cacheNearbyAllPlacesData = function(data){
    $('body').prepend('<script type="text/javascript" id="nearby_all_places_json">' + JSON.stringify(data) + '</script>');
  }

  var _clearNearbyAllPlacesDataCache = function(){
    $('#nearby_all_places_json').remove();
  }

  var _getUserZipcode = function(){
    return $('#search_map_container_div').attr('data-user-zip-code');
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
      return yellowPin;
    }
  }

  // var _getEmptyUsMap = function(){
  //   var mapOptions = {
  //     zoom: 5,
  //     center: new google.maps.LatLng(37.09024, -95.712891)
  //   }
  //   map = new google.maps.Map(_getMapDiv()[0], mapOptions);
  //   return map;
  // }

  var _getMapDiv = function(){
    return $('#map_canvas');
  }

  var _hideLoadingDiv = function(){
    $('.loading_div').hide();
  }

  var _showLoadingDiv = function(){
    $('.loading_div').show();
  }

  var _showLoadingPlacesDiv = function(){
      $('.loading_places_div').removeClass('hidden');
  }

  var _hideLoadingPlacesDiv = function(){
      $('.loading_places_div').addClass('hidden');
  }

  return {

    init:function(){
      initializeMap();
      $('.map_search_form').on('submit', drawMapFromSearch);
      $('input[name=places_options]').on('click', toggleAllOrFavoritePlaces);
    }

  }

}();
