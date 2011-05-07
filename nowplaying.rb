require 'rbosa'
require 'nkf'
Module.new do
  plugin = Plugin.create(:nowlisten)
  itunes = OSA.app 'iTunes'
  plugin.add_event(:boot) do |service|
    Thread.new do
      previous = nil
      loop do
        sleep(1)
        music = listen( itunes )
        playing = playing?( itunes )
        service.update(:message => music) if music != previous && playing
        previous = music if playing
      end
    end
  end

  def self.playing?(itunes)
    itunes.player_state == OSA::ITunes::EPLS::PLAYING
  end

  def self.listen(itunes)
    music=itunes.current_track
    name = NKF.nkf '-w', music.name
    artist = NKF.nkf '-w', music.artist
    album = NKF.nkf '-w', music.album
    hash_tag = '#nowplaying'
    return ["Listen:", name, artist, album, hash_tag].join(" ")
  end
  # boot
end
