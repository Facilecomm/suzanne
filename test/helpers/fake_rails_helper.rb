# frozen_string_literal: true

module FakeRailsHelper
  class FakeRailsEnv
    def initialize(env:)
      @env = env
    end

    def to_s
      env
    end

    attr_reader :env

    def production?
      env == 'production'
    end
  end

  class FakeRailsRoot < Pathname
    def initialize
      super 'test/fake_rails'
    end
  end

  class FakeRails
    def self.root
      FakeRailsRoot.new
    end

    def self.env
      FakeRailsEnv.new(env: env_name)
    end
  end

  class FakeDevRails < FakeRails
    def self.env_name
      'development'
    end
  end

  class FakeTestRails < FakeRails
    def self.env_name
      'test'
    end
  end

  class FakeProdRails < FakeRails
    def self.env_name
      'production'
    end
  end
end
