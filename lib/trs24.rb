#!/usr/bin/env ruby

# file: trs24.rb

require 'subunit'
require 'dynarex'
require 'mindwords'


class Trs24
  using HashDigx

  def initialize(lookup, activities, debug: false)

    @debug = debug
    @lookup, _ = RXFHelper.read(lookup)
    @activities = activities
    collect_times()

  end

  def summary()

    @h.map do |key,value|

      seconds = value[:summary][:duration]
      next unless seconds

      [key, Subunit.seconds(seconds).strfunit("%xi")]

    end.compact.to_h

  end

  def to_h()
    @h
  end

  private
  
  def collect_times()

    words = @lookup.strip.lines.flat_map {|x| x[/.*(?= #)/].split(/ *\| */)}
    new_words = @activities.map(&:first)
    @lookup += "\n" + (new_words - words).map {|x| x + ' #unknown'}.join("\n")
    @lookup += "\nunknown #other"
    puts '@lookup: ' + @lookup.inspect
    
    @mw = MindWords.new(@lookup)
    rows = @activities.map {|s, t1, t2| [t1, s, ((t2 || Time.now) - t1).round] }

    puts 'xml : ' + @mw.to_xml if @debug
    doc = Rexle.new(@mw.to_xml)
    @h = LineTree.new(@mw.to_tree).to_h

    a = rows.map do |time, activity, duration|

      puts 'activity: ' + activity if @debug
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
end
