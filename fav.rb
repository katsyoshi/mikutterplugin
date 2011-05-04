# -*- coding: utf-8 -*-
Module.new do
  plugin = Plugin::create(:fav_timeline)
  plugin.add_event(:update) do |service, message|
    fav "toshi_a", message
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
end
