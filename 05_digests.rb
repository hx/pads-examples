#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'pads'

require 'digest'

Pads.run do |pads|
  pads.push %w[MD5 SHA1 SHA256 SHA384 SHA512] do |alg|
    digest = Digest.const_get(alg)

    Pads.pad title: alg do |pad|
      pad.on_drop do |path|
        next puts "#{path} is not a file" unless path.file?

        puts "#{alg} of #{path}:"
        puts digest.hexdigest(path.binread)

        pad.with_view(title: 'Summed!', subtitle: "Check #{File.basename __FILE__} output") { sleep 2 }
      end
    end
  end
end
