#!/usr/bin/env ruby -w

require 'rubygems'
require 'bundler/setup'

require 'json'
require 'yaml'

module Linker
  class Creator
    def initialize(description: description, project: project, title: title,
                   s3_bucket: s3_bucket, s3_id: s3_id, s3_key: s3_key)
      @description = description
      @project = project
      @title = title

      @s3_bucket = s3_bucket
      @s3_id = s3_id
      @s3_key = s3_key

      create
    end

    private

    def create
      copy_template
      write_json
      write_yaml
    end

    def write_file(data:, path:)
      tree_parts = path.split '/'
      tree_parts.pop
      tree = tree_parts.join '/'

      FileUtils.mkdir_p(tree) unless File.exist?(tree)

      file = File.open path, 'w'
      file.write data
    ensure
      file.close if defined?(file)
    end

    def copy_template
      file = File.open 'src/default.html'
      data = file.read

      write_file(data: data, path: "src/#{@project}.html")
    end

    def write_json
      data = {
        'links' => [],
        'title' => @title
      }
      data['description'] = @description if @description

      write_file(data: data.to_json, path: "data/#{@project}.json")
    end

    def write_yaml
      data = {
        's3' => {
          'access_key_id' => @s3_id,
          'secret_access_key' => @s3_key,
          'bucket' => @s3_bucket
        }
      }

      write_file(data: YAML.dump(data), path: "config/#{@project}.yml")
    end
  end
end
