// Game starts on Friday, January 28th, 2000

VAR day = 1 // used to note days of the week - never goes above 7. be careful, 1 != Monday
VAR month = "January"
VAR month_day = 28
VAR day_total = 0
VAR year = 2000
VAR energy = 5 // determines time of day, and therefore available quests/locations
VAR moon = "regular"

// --- Main calendar function. Calls all other functions in this file
===function calendar(x) === // int (plus one) determines how many days advance. 0 advances time by one day.


    {x >= 0:
	    ~ day_total++
	    ~ x--
	{month_calc()}
        {weekDay()}
        {calendar(x)}
	- else:
		// {moonCycle()} // removed for being tediously hardcoded
		~ energy = 5 // "5" represents morning, so this function assumes you got a normal amount of sleep, i.e. you didn't stay up past midnight or wake up before Blockbuster opens. Manually set energy to 7 or 6 for an earlier time
	}
	
// --- displays the date at the beginning of each new day. 
=== display_date ===

    <> Today's date: {dayOfWeek(day)}, {month} {month_day}{print_ord(month_day)}, {year}. 
    -> DONE

// --- calculates the month, including leap years
===function month_calc ===
    
    { // month days
    
      
      -month == "January" && month_day > 30:
        ~ month_day = 1
        ~ month = "February"
      -(month == "February" && month_day > 28 && year % 4 == 0) || (month == "February" && month_day > 27 && year % 4 != 0): // leap year included
        ~ month = "March"
        ~ month_day = 1
      -month == "March" && month_day > 30:
        ~ month = "April"
        ~ month_day = 1
      -month == "April" && month_day > 29:
        ~ month = "May"
        ~ month_day = 1
      -month == "May" && month_day > 30:
        ~ month = "June"
        ~ month_day = 1
      -month == "June" && month_day > 29:
        ~ month = "July"
        ~ month_day = 1
      -month == "July" && month_day > 30:
        ~ month = "August"
        ~ month_day = 1
      -month == "August" && month_day > 30:
        ~ month = "September"
        ~ month_day = 1
      -month == "September" && month_day > 29:
        ~ month = "October"
        ~ month_day = 1
      -month == "October" && month_day > 30:
        ~ month = "November"
        ~ month_day = 1
      -month == "November" && month_day > 29:
        ~ month = "December"
        ~ month_day = 1
      -month == "December" && month_day > 30:
        ~ month = "January"
        ~ month_day = 1
        ~ year += 1
      -else:
        ~ month_day += 1 // do not erase
      
          // this function is accurate beyond the year the game takes place (2000)
    }

=== function weekDay ===

        {
            -day <= 6:
                ~ day += 1
            -else:
                ~ day = 1
        }

=== function timeOfDay(time)
    { time:
        - 7:    ~ return "Past Midnight"
        - 6:    ~ return "Very Early Morning" // this is quest specific and rarely seen
        - 5:    ~ return "Morning"
        - 4:    ~ return "Late Morning"
        - 3:    ~ return "Afternoon"
        - 2:    ~ return "Evening"
        - 1:    ~ return "Night"
        - 0:    ~ return "Midnight"
        - else:     ~ return "??????"
    }


=== function dayOfWeek(x)
    {daysOfWeekByIndex(x % 100)}

=== function daysOfWeekInList() 
    ~ return "{&Friday|Saturday|Sunday|Monday|Tuesday|Wednesday|Thursday}"

=== function daysOfWeekByIndex(k) 
    VAR _daysOfWeekCycleLength = 0 
    ~ return getByIndex(-> daysOfWeekInList, k, _daysOfWeekCycleLength) 
    
=== function print_ord(x) === // ordinal prefixes only, used for dates
{                             
	- x >= 10 && x <= 20:
		th
	- x mod 10 == 1:
	    st
	- x mod 10 == 2:
	    nd
	- x mod 10 == 3:
	    rd
	- else:
	    th
}

/* ---
    
    Much of the code below is adapted from Jon Ingold's github
    
    https://gist.github.com/joningold/05c72a144ec50f9d65251f13a1f47a05
    https://www.patreon.com/posts/ink-tips-text-by-32085915
    
--- */

=== function getByIndex( -> nameCycle, idx, ref cycleLength) 
    { cycleLength == 0: 
        ~ cycleLength = detectCycleLength("{nameCycle()}", nameCycle, 1)
        ~ spoolCycle(nameCycle, cycleLength - 1)
    } 
    {getNthFromCycle(nameCycle, idx, cycleLength)}
    
=== function detectCycleLength(firstInstance, -> nameCycle, k)
    ~ temp nextInstance = "{nameCycle()}" 
    { firstInstance != nextInstance: 
      //  [ {firstInstance} / {nextInstance} ]
        ~ return detectCycleLength(firstInstance, nameCycle, k+1)
    }
   // [ {k} ]
    ~ return k
 
=== function getNthFromCycle(-> nameCycle, idx, cycleLength)
    
    ~ idx = idx mod cycleLength
    { idx == 0: 
        ~ idx = cycleLength
    }
    // [ get no. {idx} ]
    ~ spoolCycle(nameCycle, idx-1)
    ~ temp nextInstance = "{nameCycle()}" 
    // [ got {nextInstance} ]
    ~ spoolCycle(nameCycle, cycleLength-idx)
    
    ~ return "{nextInstance}"
   
=== function spoolCycle(-> nameCycle, timesToSpool)
    { timesToSpool > 0:
        ~ temp nextInstance = "{nameCycle()}" 
       // [ spool through {nextInstance } ]
        ~ return spoolCycle(nameCycle, timesToSpool - 1)
    }
