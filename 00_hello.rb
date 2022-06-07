#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'pads'

Pads.run do |pads|
  pads.push title: 'Hello, Earth!'
end
