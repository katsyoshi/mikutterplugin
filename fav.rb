# -*- coding: utf-8 -*-
Module.new do
  def self.boot
    plugin = Plugin::create(:fav_timeline)
    plugin.add_event(:boot) do |service|
      Plugin.call(:setting_tab_regist, main, 'ふぁぼ')
    end
    plugin.add_event(:update) do |service, message|
      if UserConfig[:fav_users]
        UserConfig[:fav_users].split(',').each do |user|
          fav( user.strip, message ) if UserConfig[:auto_fav]
        end
      end
    end
  end

  def self.fav( target, msg )
    msg.each do |m|
      user = m.idname
      if user == target
        # ふぁぼるよ
        m.favorite(true) unless( m.favorite? || m[:retweet] )
        # リツイートするよ
        # m.retweet unless m[:retweet]
      end
    end
  end

  def self.main
    box = Gtk::VBox.new(false)
    fav_u = Mtk.group("ふぁぼるよ",
                      Mtk.input(:fav_users,"ふぁぼるゆーざ"),
                      Mtk.boolean(:auto_fav, "じどうふぁぼ"))
    box.closeup(fav_u)
  end

  boot
end
