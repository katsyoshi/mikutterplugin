# -*- coding: utf-8 -*-
require 'rbosa'

Module.new do
  def self.boot
    plugin = Plugin.create(:nowlisten)
    plugin.add_event(:boot) do |service|
      Plugin.call(:setting_tab_regist, main, 'iTunes')
    end
    plugin.add_event(:boot, &method(:nowplaying))
  end

  def self.main
    box = Gtk::VBox.new(false)
    iTunes = Mtk.group('自動ついーとする？',
                       Mtk.boolean(:iTunes, '自動ついーと'))
    box.closeup(iTunes)
  end

  def self.nowplaying(service)
    return nil unless UserConfig[:iTunes]
    OSA.utf8_strings = true
    itunes = OSA.app 'iTunes'
    itunes.run rescue system 'open -a iTunes'
    Thread.new do
      previous = nil
      loop do
        music = nil
        play = playing?(itunes)
        music = listen(itunes) if play
        if music != previous && play && UserConfig[:iTunes]
          service.update(:message => music)
          previous = music
        end
        sleep(1)
      end
    end
  end

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

  boot
end
