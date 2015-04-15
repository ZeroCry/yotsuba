require 'typhoeus'
require 'fileutils'
require 'concurrent'

module Yotsuba

  class Download
    include Concurrent::Async

    @@all_downloads = []

    attr_reader :status, :file, :id

    def initialize(options = {animefile: nil, output_dir: "." })
      @file = options[:animefile]
      @output_dir = File.absolute_path(options[:output_dir])
      @multiple = (@file.download_links.length > 1) if @file
      @status = "Queued"
      if self.valid?
        @id = @@all_downloads.length + 1
        @@all_downloads << self if self.valid?
      end

      init_mutex # Required by Concurrent::Async
    end

    def valid?
      self.file != nil
    end

    def run
      @path = @multiple ? File.join(@output_dir, @filename+".zip") : @path = File.join(@output_dir, @filename)

      FileUtils.mkdir_p @output_dir

      if File.exists? @path
        @status = "File exists"
        return
      end

      @file.download_links.each do |link|
        create_request(link).run
      end
      finish_request
    end

    def run_async
      self.async.run
    end

    def delete
      File.delete(@path) if @path
    end

    def bytes_written
      @path ? File.size(@path) : 0
    end

    def percent_downloaded
      100.0 * self.bytes_written / self.file.size
    end

    def self.all
      @@all_downloads
    end

    def self.[](key)
      return self.find_by(id: key) if key.is_a?(Fixnum)
      return self.find_by(file: key) if key.is_a?(AnimeFile)
      return self.find_by(filename: key) if key.is_a?(String)
      return self.find_by
    end

    def self.find_by(hash = {id: nil, file: nil, filename: nil, status: nil, percent_downloaded: nil})
      @@all_downloads.each do |download|
        match = check_property(download, :id, hash) ||
        check_property(download, :file, hash) ||
        check_property(download, :filename, hash) ||
        check_property(download, :status, hash) ||
        check_property(download, :percent_downloaded, hash)

        return match if match
      end
    end

    def self.find(id)
      return Download.find_by(id: id)
    end

    private

      def create_request(link)
        @status = "Downloading..."
        @file_handle ||= File.new(@path, 'ab', 0644)

        request = Typhoeus::Request.new(link, followlocation: true)
        request.on_headers do |response|
          if response.code != 200
            @status = "Download failed, #{response.code}"
          end
        end
        request.on_body do |chunk|
          @file_handle.write(chunk)
        end
        return request
      end

      def finish_request
        @status = "Complete"
        @file_handle.close
      end

      def check_property(object, symbol, hash)
        hash[symbol] && object.respond_to?(symbol) && object.send(symbol) == hash[symbol] ? object : nil
      end

  end
end
