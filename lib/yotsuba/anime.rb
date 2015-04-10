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

      raise(ArgumentError, "Argument should be a String (title), Fixnum (id), or Regexp (matches title).") if search.nil?

      @@all_animes.each &search
      return single ? results[0] : results

    end

  end
end
