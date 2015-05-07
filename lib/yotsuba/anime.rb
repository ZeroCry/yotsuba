module Yotsuba
  class Anime

    attr_reader :id, :title, :num_files

    def initialize(options = {id: nil, title: nil, num_files: nil})
      @id = options[:id]
      @title = options[:title]
      @num_files = options[:num_files]
      return self
    end

  end
end
