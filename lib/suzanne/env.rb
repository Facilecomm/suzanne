# frozen_string_literal: true

require 'suzanne/env_reader'

module Suzanne
  class Env
    class NoConfigFileFound < StandardError; end
    class NoSegmentFound < KeyError; end
    class CouldNotParseConfigFile < RuntimeError; end

    def self.rails
      Rails
    end

    def initialize
      init_config_hash
    end

    def env
      @env ||= Suzanne::EnvReader.new(
        env_config_hash
      )
    rescue KeyError
      raise NoSegmentFound, "No segment found for #{rails.env.to_s}."
    end

    private

    attr_reader :config_hash

    def init_config_hash
      return if production?

      init_from_file
    end

    def init_from_file
      check_config_file_exists
      @config_hash = YAML.load_file(config_file_path)
      check_config_hash
    end

    def env_config_hash
      return {} if production?

      config_hash.fetch(
        rails.env.to_s
      )
    rescue KeyError
      raise NoSegmentFound, "No segment found for #{rails.env.to_s}."
    end

    def check_config_file_exists
      return if config_file_exists?

      raise NoConfigFileFound
    end

    def check_config_hash
      return if config_hash.is_a?(Hash)

      raise CouldNotParseConfigFile
    end

    def config_file_exists?
      File.exist? config_file_path
    end

    def config_file_path
      rails.root.join('config', 'application.yml')
    end

    def production?
      rails.env.production?
    end

    def rails
      self.class.rails
    end
  end
end
