#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'pads'

require 'tzinfo'

ZONES = {
  'Adelaide'  => 'Australia/Adelaide',
  'Brisbane'  => 'Australia/Brisbane',
  'Canberra'  => 'Australia/Canberra',
  'Darwin'    => 'Australia/Darwin',
  'Hobart'    => 'Australia/Hobart',
  'Melbourne' => 'Australia/Melbourne',
  'Perth'     => 'Australia/Perth',
  'Sydney'    => 'Australia/Sydney',
}

class Zone
  attr_reader :display_name
  def initialize(display_name = ZONES.keys.first) = @display_name = display_name
  def now = zone.to_local(Time.now).strftime('%l:%M:%S %P').strip
  def zone = @zone ||= TZInfo::Timezone.get(ZONES.fetch display_name)
end

zones = Pads::LiveArray.new(%w[Sydney Adelaide Perth].map(&Zone.method(:new)))

Pads.run do |pads|
  pads << Pads.pad(title: '➕') do |pad|
    pad.on_click { zones << Zone.new }
  end
  pads.push zones do |zone|
    Pads.pad subtitle: zone.display_name do |pad|
      root_view = pad.view
      pad.beat(0.5) { root_view.title = zone.now }
      root_view.on_click do
        options = ZONES.keys
        options.rotate! options.find_index(zone.display_name)
        pad.push_view title: options.first do |view|
          {'👈' => -1, '👉' => 1}.each do |label, offset|
            view.button(label) { view.title = options.rotate!(offset).first }
          end
          view.on_click { zones[zones.find_index(zone)] = Zone.new(options.first) }
        end
      end
    end
  end
end
