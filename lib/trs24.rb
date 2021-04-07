#!/usr/bin/env ruby

# file: trs24.rb

require 'subunit'
require 'dynarex'
require 'mindwords'


class Trs24
  using HashDigx

  def initialize(lookup, activities, debug: false)

    @debug = debug
    @mw = MindWords.new(lookup)
    @activities = activities
    collect_times()

  end

  def collect_times()

    rows = @activities.map {|s, t1, t2| [t1, s, ((t2 || Time.now) - t1).round] }

    doc = Rexle.new(@mw.to_xml)
    @h = LineTree.new(@mw.to_tree).to_h

    a = rows.map do |time, activity, duration|

      e = doc.root.element("//[@title='#{activity}']")
      path = e.attributes[:breadcrumb].split(' / ')
      puts 'path: ' + path.inspect if @debug

      h = @h.digx(path)[:summary]
      
      h[:duration] ? h[:duration] += duration : h[:duration] = duration

      path
    end

    # tally up the duration

    a2 = a.uniq.group_by {|x| x[0..-2]}.to_a\
            .map {|key, value| [key, value.map(&:last)] }

    a2.each do |path, list|

      list.each do |activity|

        val = @h.digx(path + [activity])[:summary][:duration]

        path.length.times.each.with_index do |x,i|
          puts 'path[0..-(i+1)]:' + path[0..-(i+1)].inspect if @debug
          r = @h.digx(path[0..-(i+1)])[:summary]
          puts 'r: ' + r.inspect if @debug
          r[:duration] ? r[:duration] += val : r[:duration] = val
        end

      end

    end
    

  end

  def summary()

    @h.map do |key,value|

      seconds = value[:summary][:duration]
      next unless seconds

      duration = Subunit.new(units={minutes:60, hours:60},
                             seconds: seconds).strfunit("%xi")

       [key, duration]

    end.compact.to_h

  end

  def to_h()
    @h
  end

end
