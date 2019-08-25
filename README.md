Changes for version 2.0

+ Added the ability to change the color of the countdown timer in the settings
+ Added ability to track exhaustive charges
+ Added option to adjust Olms' timers to account for another mechanic happening first. (Disabled by default)
    - For example, if Steam is happening in 20s and Storm the Heavens is happening in 23s then the Storm the Heavens timer will be changed so it hits 0s as steam ends.
    - If two timers are too close to each other, they will not be adjusted because it's uncertain which will occur first.
+ Added option to adjust oppressive bolts timer based on if defiling blast is supposed to happen first. (Disabled by default)
+ Changed all timers to say soon instead of sitting at 0 for consistency
+ Revamped /astracker slash command
+ Toggling UI will now place a backdrop behind the notifications to show where they can be grabbed at. The dimensions of the control for the notifications will also now correctly adjust when changing the size of the notifications.
+ The Fire notification now provides a timer
+ The addon will now attempt to provide a more accurate timer for Llothis' and Felms' first cone/bolts/jump.
+ Fixed Maim Tracking
+ Restructed addon across multiple lua files for readability
+ Added Russian names for Felms/фелмс and Llothis/ллотис to provide better support for players using ruESO [https://www.esoui.com/downloads/info1347-RuESO.html]
+ General code optimization
+ Rewrote the comments for the addon for better readability
+ Added ability to override in-game language and use whatever 
 (supported) language you desire within AsylumTracker
