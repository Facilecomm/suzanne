require "test_helper"

class SuzanneTest < Minitest::Test
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

  def self.env
    FakeRailsEnv.new(env: 'development')
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

  def setup
    super
    pretend_suzanne_env_was_never_initialized
  end

  def teardown
    super
    Suzanne::Env.unstub
  end

  def test_can_initialize_env
    Suzanne::Env.stubs rails: FakeDevRails
    Suzanne.env
  end

  def test_can_retrieve_key
    Suzanne::Env.stubs rails: FakeDevRails
    assert_equal(
      'abcdef_dev',
      Suzanne.env.super_secret_key
    )
  end

  def test_can_retrieve_key_in_test_env
    Suzanne::Env.stubs rails: FakeTestRails
    assert_equal(
      'abcdef_test',
      Suzanne.env.super_secret_key
    )
  end

  def test_returns_nil_when_no_such_key_in_config_file
    Suzanne::Env.stubs rails: FakeDevRails
    assert_nil Suzanne.env.no_such_key
  end

  private

  def pretend_suzanne_env_was_never_initialized
    Suzanne.instance_variable_set(:@env, nil)
  end
end
