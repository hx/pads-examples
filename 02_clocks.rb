#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'pads'

require 'tzinfo'

ZONES = {
  'Sydney' => 'Australia/Sydney',
  'Austin' => 'America/Chicago',
  'Kyiv'   => 'Europe/Kiev',
  'UTC'    => 'UTC'
}

Pads.run do |pads|
  pads.push ZONES do |display_name, zone_name|
    zone = TZInfo::Timezone.get(zone_name)
    Pads.pad subtitle: display_name do |pad|
      pad.beat(0.5) { pad.title = zone.to_local(Time.now).strftime('%l:%M:%S %P') }
    end
  end
end
