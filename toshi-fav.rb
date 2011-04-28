# -*- coding: utf-8 -*-
Module.new do
  plugin = Plugin::create(:toshi_fav)
  plugin.add_event(:update) do |service, message|
    toshi_fav message
  end

  def self.toshi_fav( msg )
    msg.each do |m|
      user = m.idname
      if user == "toshi_a"
        # ふぁぼるよ
        m.favorite(true) unless( m.favorite? || m[:retweet] )
        m.retweet unless m[:retweet]
      end
    end
  end
end
