var duration = 1; // track the duration of the currently playing track
$(document).ready(function() {
    $('#api').bind('playingTrackChanged.rdio', function(e, playingTrack, sourcePosition) {
        if (playingTrack) {
            duration = playingTrack.duration;
            $('#art').attr('src', playingTrack.icon);
            $('#track').text(playingTrack.name);
            $('#album').text(playingTrack.album);
            $('#artist').text(playingTrack.artist);
        }
    });
    $('#api').bind('positionChanged.rdio', function(e, position) {
        $('#position').css('width', Math.floor(100*position/duration)+'%');
    });
    $('#api').bind('playStateChanged.rdio', function(e, playState) {
        if (playState == 0) { // paused
            $('#play').show();
            $('#pause').hide();
        } else {
            $('#play').hide();
            $('#pause').show();
        }
    });
    // this is a valid playback token for localhost.
    // but you should go get your own for your own domain.
    $('#api').rdio(playbackToken);

    $('#previous').click(function() { $('#api').rdio().previous(); });
    $('#play').click(function() { $('#api').rdio().play(); });
    $('#pause').click(function() { $('#api').rdio().pause(); });
    $('#next').click(function() { $('#api').rdio().next(); });

    artist_query_string = ""
    for (var i=0; i < top_five.length; i++)
    {
        artist_query_string += "&artist_id=seatwave:artist:" + top_five[i];
    }

    function getSong(sessionId) {
        $.get("http://developer.echonest.com/api/v4/playlist/dynamic?api_key=N6E4NIOVYMTHNDM8J" + "&format=json&session_id=" + sessionId, function(response) {
            var rdio_id = response["response"]["songs"][0]["foreign_ids"][0]["foreign_id"];
            rdio_id = rdio_id.split(":")[2];
            console.log(rdio_id);
            $("#api").rdio().play(rdio_id)
            $('#api').bind('playStateChanged.rdio', function(e, playState) {
                console.log("play state change!", playState);
                if (playState == 2) { // paused
                    getSong(response["response"]["session_id"]);
                }
            });            
        });
    }

    $.get("http://developer.echonest.com/api/v4/playlist/dynamic?api_key=N6E4NIOVYMTHNDM8J&bucket=id:rdio-us-streaming&" + artist_query_string + "&format=json&limit=true&type=artist-radio",
          function(response) {
              console.log("response", response);
              console.log("session id = " + response["response"]["session_id"]);
              var rdio_id = response["response"]["songs"][0]["foreign_ids"][0]["foreign_id"];
              rdio_id = rdio_id.split(":")[2];
              console.log(rdio_id);
              $("#api").rdio().play(rdio_id)
              $('#api').bind('playStateChanged.rdio', function(e, playState) {
                  console.log("play state change!", playState);
                  if (playState == 2) { // paused
                      //getSong(response["response"]["session_id"]);
                  }
              });
          });
});

