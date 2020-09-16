# frozen_string_literal: true

require 'suzanne/version'
require 'suzanne/env'

module Suzanne
  class Error < StandardError; end

  def self.env
    @env ||= Suzanne::Env.new.env
  end
end
