# frozen_string_literal: true

require 'test_helper'

class SuzanneEnvReaderTest < Minitest::Test
  def test_can_be_initialized
    config_hash = {}
    Suzanne::EnvReader.new config_hash
  end

  def test_can_be_converted_to_s
    assert_equal(
      'Suzanne env',
      env_reader.to_s
    )
  end

  def test_can_be_inspected
    assert_equal(
      'Suzanne env',
      env_reader.inspect
    )
  end

  def test_can_read_off_key
    assert_equal(
      FAKE_AWS_KEY,
      env_reader.aws_secret_key
    )
  end

  def test_can_read_off_key_with_bang
    assert_equal(
      FAKE_AWS_KEY,
      env_reader.aws_secret_key!
    )
  end

  def test_nil_when_key_is_missing
    assert_nil env_reader.google_secret_key
  end

  def test_bang_raises_when_key_is_missing
    assert_raises Suzanne::EnvReader::MissingKey do
      env_reader.google_secret_key!
    end
  end

  def test_can_check_if_key_is_present
    assert_equal(
      true,
      env_reader.aws_secret_key?
    )
  end

  def test_can_check_if_key_is_absent
    assert_equal(
      false,
      env_reader.google_secret_key?
    )
  end

  def test_can_check_if_reader_respond_to
    assert_equal(
      true,
      env_reader.respond_to?(:aws_secret_key)
    )
  end

  def test_reader_respond_to_anything_without_punctuation
    assert_equal(
      true,
      env_reader.respond_to?(:google_secret_key)
    )
  end

  def test_can_check_if_reader_respond_to_bang
    assert_equal(
      true,
      env_reader.respond_to?(:aws_secret_key!)
    )
  end

  def test_can_check_if_reader_does_not_respond_to_bang
    assert_equal(
      false,
      env_reader.respond_to?(:google_secret_key!)
    )
  end

  def test_can_check_if_reader_respond_to_question_mark
    assert_equal(
      true,
      env_reader.respond_to?(:aws_secret_key?)
    )
  end

  def test_can_check_if_reader_does_not_respond_to_question_mark
    assert_equal(
      true,
      env_reader.respond_to?(:google_secret_key?)
    )
  end

  def test_can_get_method
    assert env_reader.method(:aws_secret_key).is_a?(Method)
  end

  def test_can_get_method_with_question_bang
    assert env_reader.method(:aws_secret_key!).is_a?(Method)
  end

  def test_can_get_method_with_question_mark
    assert env_reader.method(:aws_secret_key?).is_a?(Method)
  end

  def test_method_missing
    assert_equal(
      FAKE_AWS_KEY,
      env_reader.send(:method_missing, :aws_secret_key)
    )
  end

  def test_method_missing_with_bang
    assert_equal(
      FAKE_AWS_KEY,
      env_reader.send(:method_missing, :aws_secret_key!)
    )
  end

  def test_method_missing_with_question_mark
    assert_equal(
      true,
      env_reader.send(:method_missing, :aws_secret_key?)
    )
  end

  def test_method_missing_with_edge_case_single_bang
    assert_nil env_reader.send(:method_missing, :'!')
  end

  def test_method_missing_with_empty_symbol
    assert_raises NoMethodError do
      assert_nil env_reader.send(:method_missing, :'')
    end
  end

  private

  def env_reader
    @env_reader ||= Suzanne::EnvReader.new(valid_config_hash)
  end

  FAKE_AWS_KEY = 'abcdefgh'

  def valid_config_hash
    {
      'aws_secret_key' => FAKE_AWS_KEY
    }
  end
end
