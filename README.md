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
  - [x] add new exercise page
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
    - [x] add auto fill
  - [x] push workout to database
  - [x] fetch todays workout and put it as current routine
  - [ ] add build custom routine page
    - [x] hook up the save button
    - [x] use routine service in route
    - [x] add edit functionality
    - [x] add delete functionality
    - [x] add choose image
    - [x] update all routines on exercise change
    - [x] add automatic oneOf
    - [x] add ability to reorder the exercises
    - [ ] save json
      - [ ] use more elegant solution (refactor)
      - [ ] test
  - [ ] add delete set functionality
  - [ ] add ability to switch routine
  - [ ] add ability to add exercise to existing routine
  - [x] redo choose routine page
  - [ ] create time panel wrapper widget with time service that is used on more routes
