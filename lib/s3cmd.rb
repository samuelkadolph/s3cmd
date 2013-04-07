require "aws"
require "logger"
require "mime/types"
require "proxifier/env"
require "rubygems"
require "thor"

module S3Cmd
  require "s3cmd/version"

  class CLI < Thor
    class_option :access_key, :aliases => :a, :desc => "AWS access key to use"
    class_option :credentials_file, :aliases => :c, :desc => "AWS credentials file containing the access and secret key", :default => File.expand_path("~/.aws-credentials")
    class_option :secret_key, :aliases => :s, :desc => "AWS secret key to use"

    desc "list-buckets", "lists all of your buckets"
    def list_buckets
      puts s3.buckets
    end

    desc "create-bucket name", "creates a bucket"
    method_option :region, :default => "US"
    def create_bucket(name)
      s3.bucket(name, true)
    end

    desc "list-keys bucket", "list the keys of a bucket"
    def list_keys(bucket)
      puts s3.bucket(bucket).keys
    end

    desc "get bucket key", "get the file for the key from the bucket"
    def get(bucket, key)
      puts s3.bucket(bucket).get(key)
    end

    desc "put bucket key file", "puts a file for the key in the bucket"
    option :type, :desc => "override the content type of the file"
    def put(bucket, key, file)
      bucket = s3.bucket(bucket)
      type = options[:type] || MIME::Types.of(file).first.to_s
      File.open(file, "r") { |f| bucket.put(key, f, {}, nil, { "content-type" => type }) }
    end

    private
    def credentials
      return @credentials if defined?(@credentials)

      access_key = secret_key = nil

      if options[:access_key] || options[:secret_key]
        access_key = options[:access_key]
        secret_key = options[:secret_key]
      else
        File.open(options[:credentials_file]) do |file|
          file.lines.each do |line|
            access_key = $1 if line =~ /^AWSAccessKeyId=(.*)$/
            secret_key = $1 if line =~ /^AWSSecretKey=(.*)$/
          end
        end
      end

      @credentials = [access_key, secret_key]
    end

    def s3
      return @s3 if defined?(@s3)

      access_key, secret_key = credentials

      unless access_key
        $stderr.puts("No access key provided")
        exit 1
      end

      unless secret_key
        $stderr.puts("No secret key provided")
        exit 1
      end

      logger = Logger.new(STDERR)
      logger.level = Logger::FATAL

      @s3 = Aws::S3.new(access_key, secret_key, :logger => logger)
    end
  end
end
