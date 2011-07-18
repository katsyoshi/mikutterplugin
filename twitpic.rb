# -*- coding: utf-8 -*-
# require 'twitpic'
miquire :core,'environment'
miquire :core,'post'
Module.new do
  @pic = Post.new
  def self.boot
    plugin = Plugin::create(:twitpic)
    plugin.add_event(:boot) do |service|
      Plugin.call(:setting_tab_regist, main, 'twitpic')
    end
    plugin.add_event(:boot) do |service,message|
      if UserConfig[:twitpic_img] && @pic.twitter.imageuploadable?
        img = UserConfig[:twitpic_img]
        UserConfig[:twitpic_img] = nil
        p @pic.twitter.uploadimage(img,
                                   message)
      end
    end
  end

  def self.main
    box = Gtk::VBox.new false
    twitpic = Mtk.group('twitpic',
                        Mtk.fileselect(:twitpic_img,"image"))
    box.closeup(twitpic)
  end

  boot
end
