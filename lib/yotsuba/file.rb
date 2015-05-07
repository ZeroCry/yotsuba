module Yotsuba
  class AnimeFile

    attr_reader :id, :name, :size, :first_downloaded, :times_downloaded, :anime

    def initialize(options = {id: nil, name: nil, size: nil, first_downloaded: nil, times_downloaded: nil, anime: nil})
      @id = options[:id]
      @name = options[:name]
      @size = options[:size]
      @first_downloaded = options[:first_downloaded]
      @times_downloaded = options[:times_downloaded]
      @anime = options[:anime]
      return self
    end

  end
end
