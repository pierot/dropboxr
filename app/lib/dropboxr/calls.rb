require 'cgi'

module Dropboxr

  module Calls

    def self.before(*names)
      names.each do |name|
        m = instance_method(name)

        define_method(name) do |*args, &block|
          yield

          m.bind(self).(*args, &block)
        end
      end
    end

    before(*instance_methods) { authorized? }

    def get_gallery(path)
      authorized?

      @client.metadata path
    end

    def get_galleries(directory = 'Photos')
      result = @client.metadata directory
      result["contents"]
    end

    def get_photos(gallery)
      result = @client.metadata gallery
      result["contents"]
    end

    def get_image(path, options={})
      # defaults
      size = options[:size] || ''

      # validation
      return nil unless ['small', 'medium', 'large', 'huge', 'original', ''].include? size

      # conversion
      size = 'xl' if size == 'huge'
      size = '75x75_fit_one' if size == 'medium'

      # http://forums.dropbox.com/topic.php?id=26965&replies=18

      authorized?

      begin
        if size == 'original'
          p path
          @client.get_file path
        else
          path = CGI.escape path
          path.gsub! '+', '%20'

          @client.thumbnail path, size
        end
      rescue DropboxError => e
        p e

        nil
      end
    end

  end

end
