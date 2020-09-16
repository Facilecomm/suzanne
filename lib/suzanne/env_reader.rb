# frozen_string_literal: true

module Suzanne
  class EnvReader
    class MissingKey < StandardError
      def initialize(key)
        super("Missing required configuration key: #{key.inspect}")
      end
    end

    # ENV takes priority over config_hash
    def initialize(config_hash)
      @env = config_hash.merge(ENV)
    end

    def to_s
      'Suzanne env'
    end

    def inspect
      'Suzanne env'
    end

    def respond_to?(method, *)
      key, punctuation = extract_key_from_method(method)

      case punctuation
      when '!' then key?(key) || super
      when '?', nil then true
      else super
      end
    end

    private

    attr_reader :env

    def method_missing(method, *)
      key, punctuation = extract_key_from_method(method)

      return get_value(key) unless punctuation
      return fetch_key!(key) if punctuation == '!'
      return !!send(key) if punctuation == '?'

      super
    end

    def respond_to_missing?(method, *)
      key, punctuation = extract_key_from_method(method)

      return true unless punctuation
      return true if punctuation == '?'
      return (key?(key) || super) if punctuation == '!'

      super
    end

    def fetch_key!(key)
      send(key) || missing_key!(key)
    end

    def extract_key_from_method(method)
      method.to_s.downcase.match(%r{^(.+?)([!?=])?$}).captures
    end

    def key?(key)
      env.any? { |k, _| k.downcase == key }
    end

    def missing_key!(key)
      raise MissingKey.new(key) # rubocop:disable Style/RaiseArgs
    end

    def get_value(key)
      _, value = env.detect { |k, _v| k.downcase == key }
      value
    end
  end
end
