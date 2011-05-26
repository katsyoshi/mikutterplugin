require 'rbosa'
# require 'nkf'

def listen(itunes)
  music=itunes.current_track
  name = music.name
  artist = music.artist
  album = music.album
  hash_tag = '#nowplaying'
  return [name, artist, album, hash_tag].join(" ")
end

def playing?( itunes )
  itunes.player_state == OSA::ITunes::EPLS::PLAYING
end

def loop_test itunes
  psong = nil
  loop do
    playing = playing?( itunes )
    music = listen itunes if playing
    if music != psong && playing
      print music, "\n"
      psong = music
    end
    sleep 1
  end
end
OSA.utf8_strings = true
itunes = OSA.app'iTunes'
# itune.run rescue system 'open -a iTunes'
loop_test itunes
