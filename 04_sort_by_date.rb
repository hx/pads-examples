#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'pads'

require 'fileutils'

VARIATIONS = {
  'Sort by month' => '%Y/%m',
  'Sort by day'   => '%Y/%m/%d'
}

Pads.run do |pads|
  pads.push VARIATIONS do |title, date_format|
    Pads.pad title: title do |pad|
      pad.on_drop do |dir|
        next pad.with_view(title: 'Not a dir', subtitle: dir.basename) { sleep 2 } unless dir.directory?

        glob  = Dir[dir.join('**/*.*').to_s]
        count = glob.length.to_f
        moved = 0
        pad.with_view title: 'Organising …' do |view|
          glob.each.with_index do |actual_path, index|
            view.activity = (index + 1) / count
            actual_path   = Pathname(actual_path)
            time          = actual_path.mtime
            expected_path = dir + time.strftime(date_format) + actual_path.basename
            unless actual_path == expected_path
              expected_path.parent.mkpath
              puts '%s => %s' % [actual_path, expected_path]
              actual_path.rename expected_path
              moved += 1
            end
          end
        end
        pad.with_view(title: moved.zero? ? 'Nothing moved' : "#{moved} files moved") { sleep 2 }
      end
    end
  end

  # This pad makes a bunch of empty files with random dates for testing.
  pads << Pads.pad do |pad|
    pad.title = '🤩'

    number_of_files = 200
    maximum_age = 86400 * 60 # 60 days

    pad.on_drop do |dir|
      next pad.with_view(title: 'Not a dir', subtitle: dir.basename) { sleep 2 } unless dir.directory?

      pad.with_view title: 'Fabricating …' do |view|
        (1..number_of_files).each do |num|
          view.activity = num / number_of_files.to_f
          FileUtils.touch dir.join('IMG_%04d.jpg' % num).to_s, mtime: Time.now - rand(maximum_age)
        end
      end
    end
  end
end
