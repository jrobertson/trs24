# Introducing the Trs24 gem

    require 'trs24'

    activities = "
    drying dishes # 10:09 # 10:12
    dishes        # 10:19 # 10:21
    drying dishes # 10:22 # 10:26
    dishes        # 10:27 # 10:33
    lunch         # 12:13 # 13:20
    dev           # 13:39 # 16:41
    "

    lookup = "
    drying dishes #housework #kitchen #chores
    dishes #housework #kitchen #chores
    housework #chores
    kitchen #housework
    dev #SoftwareDevelopment
    lunch #meal
    breakfast #meal
    teatime | dinner | meal | mealtime #meal
    microblog #dev
    sleep |sleeping | bed time | in bed #sleep
    washed and dressed #tasks #personal
    personal #tasks
    chores #tasks
    bath | bathing #tasks #personal
    "

    a = activities.strip.lines.map do |line| 
      s, t1, t2 = line.split(/ +# +/,3); 
      [s, Time.parse(t1), Time.parse(t2)]
    end

    trs = Trs24.new(lookup, a, debug: false)
    trs.summary #=> {"SoftwareDevelopment"=>"3h 2m", "meal"=>"1h 7m", "tasks"=>"15m"} 

In the above example the number of total hours for each activity is summarised, grouped by the associated top-level hashtag.

## Resources

* trs24 https://rubygems.org/gems/trs24

trs trs24 gem timerecordingsystem activitylogger reporting report
