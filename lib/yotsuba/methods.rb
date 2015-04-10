module Yotsuba

  def self.setup_savon
    @client ||= Savon.client(wsdl: 'http://anime.domdomsoft.com/Services/MainService.asmx?wsdl')
  end

  def self.get_animes
    setup_savon
    Anime.clear_anime_list!
    response = @client.call(:get_anime_list)
    animes = response.body[:get_anime_list_response][:get_anime_list_result][:anime]
    animes.each do |a|
      Anime.new({
        id: a[:id].to_i,
        title: a[:title],
        num_files: a[:num_file].to_i
      })
    end
    return animes.length > 0
  end

  def self.get_files(anime)
    setup_savon
    response = @client.call(:get_list_episode, message: { animeTitle: anime.title, serial: Serial })
    files = response.body[:get_list_episode_response][:get_list_episode_result][:episode_file]
    results = []
    files = [files] unless files.is_a?(Array)
    files.each do |f|
      results << File.new({
        id: f[:id].to_i,
        name: f[:name],
        size: f[:file_size].to_i,
        first_downloaded: f[:first_download_time_in_day],
        times_downloaded: f[:download_times].to_i,
        anime_id: anime.id
      })
    end
    return results
  end

  def self.get_download_links(file)
    setup_savon
    response = @client.call :request_link_download2, message: { animeTitle: file.anime.title, episodeName: file.name, serial: Serial }
    links = response.body[:request_link_download2_response][:request_link_download2_result].split('|||')
  end

end
