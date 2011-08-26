require "rubygems"
require "aws"
require "mime/types"
require "proxifier/env"
require "thor"

module S3Cmd
  require "s3cmd/version"

  class Main < Thor
    desc "list-buckets", "lists all of your buckets"
    def list_buckets
      puts s3.buckets
    end

    desc "create-bucket name", "creates a bucket"
    method_option :region, :default => "US"
    def create_bucket(name)
      bucket = s3.bucket(name, true)
    end

    desc "list-keys bucket", "list the keys of a bucket"
    def list_keys(bucket)
      puts s3.bucket(bucket).keys
    end

    desc "get bucket key", "get the file for the key from the bucket"
    def get(bucket, key)
      bucket = s3.bucket(bucket)
      $stdout << bucket.get(key)
    end

    desc "put bucket key file", "puts a file for the key in the bucket"
    method_option :type, :desc => "override the content type of the file", :type => :string
    def put(bucket, key, file)
      bucket = s3.bucket(bucket)
      type = options[:type] || MIME::Types.of(file).first.to_s
      File.open(file, "r") { |f| bucket.put(key, f, {}, nil, { "content-type" => type }) }
    end

    private
      def s3
        @s3 ||= begin
          access_key, secret_key = nil, nil

          if ENV["AWS_CREDENTIAL_FILE"]
            File.open(ENV["AWS_CREDENTIAL_FILE"]) do |file|
              file.lines.each do |line|
                access_key = $1 if line =~ /^AWSAccessKeyId=(.*)$/
                secret_key = $1 if line =~ /^AWSSecretKey=(.*)$/
              end
            end
          elsif ENV["AWS_ACCESS_KEY"] || ENV["AWS_SECRET_KEY"]
            access_key = ENV["AWS_ACCESS_KEY"]
            secret_key = ENV["AWS_SECRET_KEY"]
          end

          unless access_key
            $stderr.puts "AWS_CREDENTIAL_FILE must containt AWSAccessKeyId or AWS_ACCESS_KEY must be set"
            exit 1
          end
          unless secret_key
            $stderr.puts "AWS_CREDENTIAL_FILE must containt AWSSecretKey or AWS_SECRET_KEY must be set"
            exit 1
          end

          logger = Logger.new(STDERR)
          logger.level = Logger::FATAL

          Aws::S3.new(access_key, secret_key, :logger => logger)
        end
      end
  end
end
