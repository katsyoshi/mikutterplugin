Module.new do 
  plugin = Plugin::create(:toshi_fav)
  plugin.add_event(:update) do |service, message|
    toshi_fav message 
  end

  def self.toshi_fav( msg )
    msg.each do |s|
      user = s.idname 
      if user == "toshi_a"
        s.favorite(true) unless s.favorite? && /^RT/ =~ s.to_show 
      end
    end
  end
end
