require 'yotsuba/version'
require 'savon'

module Yotsuba

  Serial = ENV['DOMDOM_KEY']

  class Anime
    attr_reader :id, :title, :num_files

    @@all_animes = []

    def initialize(options = {id: nil, title: nil, num_files: nil})
      @id = options[:id]
      @title = options[:title]
      @num_files = options[:num_files]
      @@all_animes << self if self.valid?
      return self
    end

    def valid?
      self.id != nil && self.title != nil && self.num_files != nil
    end

    def files
      @files ||= Yotsuba.get_files(self)
    end

    def self.clear_anime_list!
      @@all_animes = []
    end

    def self.all
      Yotsuba.get_animes if @@all_animes.length == 0
      @@all_animes
    end

    def self.[](key)
      Yotsuba.get_animes if @@all_animes.length == 0
      results = []
      single = false

      search = Proc.new { |a|
        single = true
        results << a if a.title == key
      } if key.is_a?(String)

      search = Proc.new { |a|
        single = true
        results << a if a.id == key
      } if key.is_a?(Fixnum)

      search = Proc.new { |a|
        single = false
        results << a if a.title.match(key)
      } if key.is_a?(Regexp)

      raise(ArgumentError, "Argument should be a String (title), Fixnum (id), or Regexp.") if search.nil?

      @@all_animes.each &search
      return single ? results[0] : results

    end

  end

  class File

    attr_reader :id, :name, :size, :first_downloaded, :times_downloaded, :anime_id

    def initialize(options = {id: nil, name: nil, size: nil, first_downloaded: nil, times_downloaded: nil, anime_id: nil})
      @id = options[:id]
      @name = options[:name]
      @size = options[:size]
      @first_downloaded = options[:first_downloaded]
      @times_downloaded = options[:times_downloaded]
      @anime_id = options[:anime_id]
      return self
    end

    def anime
      @anime ||= Yotsuba::Anime[self.anime_id]
    end

    def download_links
      @download_links ||= Yotsuba.get_download_links(self)
    end

  end

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
