$(function(){
  GoogleMapSearch.init();
});

var GoogleMapSearch = function(){

  var drawMap = function(address){
    var myForm = $(this);
    var address = myForm.find('input[name=search]').val();
    geocoder = new google.maps.Geocoder();
    geocoder.geocode({'address': address}, function(results, status){
      var lat = results[0].geometry.location.lat();
      var lng = results[0].geometry.location.lng();
      mapOptions = {
        zoom: 12,
        center: new google.maps.LatLng(lat, lng)
      }
      map = new google.maps.Map(document.getElementById('search_map_canvas'), mapOptions);
      google.maps.event.addListener(map, 'idle', function() {
        findAndDrawFavoritePlaces(map);
      });
    });
  }

  var findAndDrawFavoritePlaces = function(map){
    $.ajax({
      url: '/map/favorite_place_locations.json',
      method: 'GET'
    }).done(function(data){
      $(data).each(function(idx, coords){
        var latLng = new google.maps.LatLng(coords.lat, coords.lng);
        if(map.getBounds().contains(latLng)){
          var marker = new google.maps.Marker({
            position: latLng,
            map: map,
            title: coords.name
          });
        }
      });
    });
  }

  return {

    init:function(){
      $('.map_search_form').on('submit', drawMap);
    }

  }

}();
