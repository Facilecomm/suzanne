# frozen_string_literal: true

require 'test_helper'
require 'helpers/fake_rails_helper'

class SuzanneTest < Minitest::Test
  include FakeRailsHelper

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

  def test_rails_constant_be_initialized
    error = assert_raises NameError do
      Suzanne.env
    end
    assert_equal(
      'uninitialized constant Rails',
      error.message
    )
  end

  def test_can_retrieve_key
    Suzanne::Env.stubs rails: FakeDevRails
    assert_equal(
      'abcdef_dev',
      Suzanne.env.super_secret_key
    )
  end

  def test_can_retrieve_key_with_bang
    Suzanne::Env.stubs rails: FakeDevRails
    assert_equal(
      'abcdef_dev',
      Suzanne.env.super_secret_key!
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

  def test_bang_method_raises_when_no_such_key_in_config_file
    Suzanne::Env.stubs rails: FakeDevRails

    assert_raises Suzanne::EnvReader::MissingKey do
      Suzanne.env.no_such_key!
    end
  end

  def test_can_check_if_key_is_present
    Suzanne::Env.stubs rails: FakeDevRails
    assert_equal true, Suzanne.env.super_secret_key?
  end

  def test_can_check_if_key_is_missing
    Suzanne::Env.stubs rails: FakeDevRails
    assert_equal false, Suzanne.env.no_such_key?
  end

  def test_raises_if_no_section_corresponding_to_env
    Suzanne::Env.stubs(
      rails: FakeDevRails,
      root_relative_config_file_path: ['config', 'no_dev_application.yml']
    )
    assert_raises Suzanne::Env::NoSegmentFound do
      Suzanne.env
    end
  end

  def test_raises_if_file_does_not_exists
    Suzanne::Env.stubs(
      rails: FakeDevRails,
      root_relative_config_file_path: ['config', 'no_such_file.yml']
    )
    assert_raises Suzanne::Env::NoConfigFileFound do
      Suzanne.env
    end
  end

  def test_raises_if_file_cannot_be_parsed
    Suzanne::Env.stubs(
      rails: FakeDevRails,
      root_relative_config_file_path: ['config', 'not_yaml.yml']
    )
    assert_raises Suzanne::Env::CouldNotParseConfigFile do
      Suzanne.env
    end
  end

  def test_does_not_attempt_to_read_file_in_production
    Suzanne::Env.stubs(
      rails: FakeProdRails
    )
    Suzanne.env
    Suzanne.env.some_key
  end

  def test_read_off_ENV_in_production
    Suzanne::Env.stubs(
      rails: FakeProdRails
    )
    Suzanne.env

    # Sanity check
    assert ENV['USER']

    assert_equal(
      ENV['USER'],
      Suzanne.env.USER
    )
  end

  def test_ENV_takes_priority_over_config_file_in_dev
    Suzanne::Env.stubs(
      rails: FakeDevRails,
      root_relative_config_file_path: ['config', 'application.yml']
    )
    Suzanne.env

    # Sanity check
    assert ENV['USER']

    assert_equal(
      ENV['USER'],
      Suzanne.env.USER
    )

  end

  private

  def pretend_suzanne_env_was_never_initialized
    Suzanne.instance_variable_set(:@env, nil)
  end
end
