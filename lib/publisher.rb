#!/usr/bin/env ruby -w

require 'rubygems'
require 'bundler/setup'

require 'aws/s3'
require 'yaml'

module Linker
  class Publisher
    def initialize(project: project)
      @project = project
      @path = "public/#{@project}"

      @s3_bucket = @s3_id = @s3_key = nil

      publish
    end

    private

    def publish
      get_config
      connect_s3
      get_bucket
      publish_project
    end

    def get_bucket
      AWS::S3::Bucket.find @s3_bucket
    rescue AWS::S3::NoSuchBucket
      AWS::S3::Bucket.create @s3_bucket
    end

    def get_config
      file = File.open "config/#{@project}.yml", 'r'
      raw_data = file.read

      data = YAML.load raw_data

      @s3_bucket = data['s3']['bucket']
      @s3_id = data['s3']['access_key_id']
      @s3_key = data['s3']['secret_access_key']
    end

    def connect_s3
      AWS::S3::Base.establish_connection!(
        access_key_id: @s3_id,
        secret_access_key: @s3_key
      )
    end

    def publish_file(name:)
      file = File.open "#{@path}/#{name}"
      data = file.read

      AWS::S3::S3Object.store name, data, @s3_bucket
    end

    def publish_project
      files = %w(application.css application.js index.html)
      files.each { |file| publish_file(name: file) }
    end
  end
end
