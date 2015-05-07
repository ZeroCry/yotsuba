module Yotsuba
  module Messenger

    def self.get_animes(options = {use_cache: false})
      setup
      return @animes if options[:use_cache] && @animes.length > 0
      response = @client.call(:get_anime_list)
      animes = response.body[:get_anime_list_response][:get_anime_list_result][:anime]
      animes = [animes] unless animes.is_a?(Array)
      results = []
      animes.each do |a|
        results << {
          id: a[:id].to_i,
          title: a[:title],
          num_files: a[:num_file].to_i
        }
      end
      @animes = results if options[:use_cache]
      return results
    end

    def self.get_files(anime)
      setup
      response = @client.call(:get_list_episode, message: { animeTitle: anime.title, serial: Yotsuba::Serial })
      files = response.body[:get_list_episode_response][:get_list_episode_result][:episode_file]
      files = [files] unless files.is_a?(Array)
      results = []
      files.each do |f|
        results << {
          id: f[:id].to_i,
          name: f[:name],
          size: f[:file_size].to_i,
          first_downloaded: f[:first_download_time_in_day],
          times_downloaded: f[:download_times].to_i,
          anime: anime
        }
      end
      return results
    end

    def self.get_download_links(file)
      setup
      response = @client.call :request_link_download2, message: { animeTitle: file.anime.title, episodeName: file.name, serial: Yotsuba::Serial }
      links = response.body[:request_link_download2_response][:request_link_download2_result].split('|||')
      links = [links] unless links.is_a?(Array)
      return links
    end

    private

      def self.setup
        @client ||= Savon.client(wsdl: 'http://anime.domdomsoft.com/Services/MainService.asmx?wsdl')
        @animes ||= []
      end

  end
end
