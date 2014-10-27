#!/usr/bin/env ruby -w

require 'rubygems'
require 'bundler/setup'

require 'json'

module Linker
  class Adder
    def initialize(description: description, project: project, url: url)
      @description = description
      @project = project
      @data_path = "data/#{@project}.json"
      @url = url

      @data = get_data

      add
    end

    private

    def add
      append_link
      write_file
    end

    def append_link
      new_link = {
        'created_at' => Time.now.iso8601,
        'url' => @url
      }
      new_link['description'] = @description if @description

      @data['links'] << new_link
    end

    def get_data
      file = File.open @data_path, 'r'
      raw_data = file.read

      JSON.parse raw_data
    end

    def write_file
      file = File.open @data_path, 'w'
      file.write @data.to_json
    ensure
      file.close if defined?(file)
    end
  end
end
