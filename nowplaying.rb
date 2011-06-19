# -*- coding: utf-8 -*-
require 'rbosa'

Module.new do
  class << self
    def define_command(slug, args)
      type_strict args => Hash
      args[:slug] = slug.to_sym
      args.freeze
      Plugin.create(:nowplaying).add_event_filter(:command){|menu|
        menu[slug] = args
        [menu]
      }
    end
  end

  def self.exec_player? itunes
    itunes.run
  rescue
    system 'open -a iTunes'
  end

  OSA.utf8_strings = true
  itunes = OSA.app 'iTunes'
  exec_player? itunes

  define_command(:playing,
                 :name => itunes.current_track.name,
                 :condition => lambda do |m|
                   m.post.editable? end,
                 :exec => lambda do |m|
                   p m.active
                 end,
                 :visible => true,
                 :role => :postbox)
                 # def self.nowplaying(service)

  def self.playing?(itunes)
    itunes.player_state == OSA::ITunes::EPLS::PLAYING
  end

  def self.listen(itunes)
    music = itunes.current_track
    name = music.name
    artist = music.artist
    album = music.album
    hash_tag = '#nowplaying'
    return ["Listen:", name, artist, album, hash_tag].join(" ")
  end

end
