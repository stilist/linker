#!/usr/bin/env ruby -w

require 'rubygems'
require 'bundler/setup'

require 'fileutils'
require 'handlebars'
require 'json'

module Linker
  class Builder
    def initialize(project: project)
      @project = project

      @path = "public/#{@project}"
      create_path

      @data = get_data
      @template = get_template

      build
    end

    private

    def build
      write_page
      copy_static_files
    end

    def get_data
      file = File.open "data/#{@project}.json"
      raw_data = file.read
      data = JSON.parse raw_data

      if data['links'] && data['links'].length > 0
        current_link = data['links'].pop
        previous_links = data['links']

        links = {
          'current_link' => current_link,
          'previous_links' => previous_links
        }
        data.merge!(links)
      end

      data
    end

    def get_template
      handlebars = Handlebars::Context.new
      file = File.open "src/#{@project}.html"
      template_str = file.read
      handlebars.compile template_str
    end

    def create_path
      FileUtils.mkdir_p(@path) unless File.exist?(@path)
    end

    def write_page
      compiled = @template.call @data

      File.open("#{@path}/index.html", 'w') { |f| f.write compiled }
    end

    def copy_static_files
      files = %w(application.css application.js)
      files.each { |file| FileUtils.copy_file "src/#{file}", "#{@path}/#{file}" }
    end
  end
end
