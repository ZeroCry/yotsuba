module Yotsuba
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
      precache_animes
      @@all_animes
    end

    def self.[](key)
      return Anime.find_by(title: key) if key.is_a?(String)
      return Anime.find_by(id: key) if key.is_a?(Fixnum)
      return Anime.search(key) if key.is_a?(Regexp)

      raise(ArgumentError, "Argument should be a String (title), Fixnum (id), or Regexp (matches title).")
    end

    def self.find_by(hash = {title: nil, id: nil})
      precache_animes
      @@all_animes.each do |anime|
        match = check_property(anime, :id, hash) || check_property(anime, :title, hash)
        return match if match
      end
      return nil
    end

    def self.find(id)
      Anime.find_by(id: id)
    end

    def self.search(regexp)
      precache_animes
      results = []
      @@all_animes.each do |anime|
        results << anime if anime.title.match(regexp)
      end
      return results
    end

    private

      def self.precache_animes
        Yotsuba.get_animes if @@all_animes.length == 0
      end

      def self.check_property(object, symbol, hash)
        hash[symbol] && object.respond_to?(symbol) && object.send(symbol) == hash[symbol] ? object : nil
      end

  end
end
