# Track Workouts

## todos

- [x] fetch workouts from api
- [x] add proper error handling
- [x] create infinite listView that automatically loads more data
- [x] create ui
    - [x] build root route ui
    - [x] build details route ui
        - [x] add type safety for set attributes by using enums
        - [x] put pre break between each set
        - [x] if an attribute is the same for all sets, put it on top of the view
        - [x] add units by using an extension on Map
        - [x] redo set widget

- [x] refactor by adding .copy()

- [ ] add 'new workout' route
    - [x] add bottom navigation button
    - [x] add list of current exercises
    - [ ] add new exercise page
        - [x] add break time == null error handling
        - [x] allow some attributes to be null on condition (eg. weight can be null if band level is not).
        - [x] add break picker
        - [x] store set data in new_workout_service
        - [x] add edit functionality
        - [x] add colors to new workout route
        - [x] add time panel
            - [x] fix countdown timer speed
            - [x] add sound effect
            - [x] add timer
        - [ ] add auto fill
    - [ ] push workout to database
    - [ ] fetch todays workout and put it as current routine
    - [ ] add build custom routine page
    - [ ] add button that adds custom exercise
    - [ ] redo choose routine page

- [ ] add edit functionality to details route