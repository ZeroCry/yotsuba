module Yotsuba
  class AnimeFile

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

    def download(output_dir)
      Download.new(filename: self.name, part_links: self.download_links, output_dir: output_dir)
    end

  end
end
