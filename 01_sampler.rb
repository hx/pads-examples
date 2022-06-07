#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'pads'

Pads.run do |pads|
  # A simple counter
  pads << Pads.pad do |pad|
    pad.title = number = 1
    {'➖' => -1, '➕' => 1}.each do |label, diff|
      pad.button(label) { pad.title = (number += diff) }
    end
  end

  # A pad that displays the 👋 emoji, and says Hi when clicked.
  pads << Pads.pad(title: '👋') do |pad|
    pad.on_click { `say 'Hello everybody!'` }
  end

  # A very moody pad (a different emotion every 500ms)
  pads << Pads.pad do |pad|
    pad.beat(0.5) { pad.title = %w[😀 🤪 😂 😍 😱 🤢 😲 🥴 🥺].sample }
  end

  # A semi-useful pad that shows CPU usage every 3 seconds
  pads << Pads.pad(title: 'CPU') do |pad|
    pad.beat 3 do
      usage = `ps -A -o %cpu`.lines.map(&:to_f).sum / 100.0
      pad.subtitle = '%0.1f%%' % (usage * 100)
      pad.activity = usage
    end
  end

  # A pad that looks like it's doing something
  pads.push title: 'One moment …', activity: true

  # A pad that complains when you click on it
  pads << Pads.pad(subtitle: "Don't hurt me!") do |pad|
    pad.on_click do
      pad.with_view(title: 'Ouch!') { sleep 2 }
    end
  end
end
