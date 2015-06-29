$(function(){
  GoogleMapSearch.init();
});

var GoogleMapSearch = function(){

  var initializeMap = function(){
    var mapDiv = _getMapDiv();
    if(navigator.geolocation){
  		navigator.geolocation.getCurrentPosition(
        function(position){
          var map = _getGoogleMap(position.coords.latitude, position.coords.longitude);
          google.maps.event.addListener(map, 'idle', function(){
            drawMap(map);
          });
        },
        function(error){// it's possible that the user is not allowing geolocation, even though it's available
          var map = _getEmptyUsMap();
          google.maps.event.addListener(map, 'idle', function(){
            drawUsMap(map);
          });
        }
      );
    }
  	else {// gelocation is not available
      var map = _getEmptyUsMap();
      google.maps.event.addListener(map, 'idle', function(){
        drawUsMap(map);
      });
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
    var favePlaces = JSON.parse($('#favorite_places_json').html());
    $(favePlaces).each(function(idx, place){
      var latLng = new google.maps.LatLng(place.lat, place.lng);
      if(map.getBounds().contains(latLng)){
        var marker = new google.maps.Marker({
          position: latLng,
          map: map,
          title: place.name
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
      $(data).each(function(idx, place){
        var latLng = new google.maps.LatLng(place.lat, place.lng);
        if(map.getBounds().contains(latLng)){
          var marker = new google.maps.Marker({
            position: latLng,
            map: map,
            title: place.name
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

  var drawUsMap = function(map){
    if(_getMapDiv().attr('all-places') != 'true'){
      drawUsMapWithFavoritePlaces(map);
    }
    _hideLoadDiv();
  }

  var drawUsMapWithFavoritePlaces = function(map){
    var favePlaces = JSON.parse($('#favorite_places_json').html());
    $(favePlaces).each(function(idx, place){
      var latLng = new google.maps.LatLng(place.lat, place.lng);
      if(map.getBounds().contains(latLng)){
        var marker = new google.maps.Marker({
          position: latLng,
          map: map,
          title: place.name
        });
      }
    });
  }

  var _getGoogleMap = function(lat, lng, opts){
    var mapOptions = {
      zoom: 10,
      center: new google.maps.LatLng(lat, lng)
    }
    mapOptions = $.extend({}, mapOptions, opts || {});
    map = new google.maps.Map(_getMapDiv()[0], mapOptions);
    return map;
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
