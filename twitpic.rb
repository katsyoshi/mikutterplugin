require 'twitpic'
miquire :core,'environment'
Module.new do
  DEFAULT_PIC_DIR=File.expand_path '~/'
  def self.twit
    @twitpic = TwitPic::Client.new
    @twitpic.configure do |conf|
      conf.api_key = "b40e6b9937404982439f2c6b0116e258"
      conf.consumer_key = Environment::TWITTER_CONSUMER_KEY
      conf.consumer_secret = Environment::TWITTER_CONSUMER_SECRET
      conf.oauth_token = UserConfig[:twitter_token]
      conf.oauth_secret= UserConfig[:twitter_secret]
    end
  end

  def self.boot
    plugin = Plugin.create(:twitpic)
    plugin.add_event(:boot) do |service|
      Plugin.call(:setting_tab_regist, main, "TwitPic")
    end
    twit
  end

  def self.main
    box = Gtk::VBox.new(false)
    pic = Mtk.group("tweetpic",
                    Mtk.fileselect(:pic, "photo", DEFAULT_PIC_DIR))
    box.closeup(pic)
  end

  boot
end
