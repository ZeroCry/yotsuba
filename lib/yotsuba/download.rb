module Yotsuba
  class Download
    include Concurrent::Async

    attr_reader :status, :file, :id

    def initialize(options = {animefile: nil, output_dir: "." })
      @file = options[:animefile]
      @output_dir = File.absolute_path(options[:output_dir])
      @multiple = (@file.download_links.length > 1) if @file
      @status = "Queued"

      init_mutex # Required by Concurrent::Async
    end

    def run
      @path = @multiple ? File.join(@output_dir, @file.name+".zip") : @path = File.join(@output_dir, @file.name)

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

    def abort
      finish_request
      @status = "Aborted"
    end

    def delete
      abort if @status != "Aborted"
      File.delete(@path) if @path
      return true
    end

    def bytes_written
      @path ? File.size(@path) : 0
    end

    def percent_downloaded
      100.0 * self.bytes_written / self.file.size
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

  end
end
