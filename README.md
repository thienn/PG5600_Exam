# PG5600_Exam

#### App summary:
Connect via REST-API to get data from. SWAPI.co - to get films and characters. Save some of the data locally in Core data - favorite ones. So ability to add & remove films / characters to and from favorite list. From favorites tab click on character to see all the movies the character appeared in. And lastly, recommend a movie based on how many how many favorite characters you have in them.

## Current version
Xcode 10.1, Swift 4.2 and AlamoFire 4.7(cocoaPods depended)
Tested mainly on iPhone 8 simulator and iPhone Xs / 8 Plus to see if there was any major problems in some others

Icons from - https://icons8.com/ios (Free to use)

TableView and collectionView to see films and characters fully implemented
You can click into details on films add / remove them from favorites
In characters you can see all the characters from page 1-3. Add or remove them as favorites. With orange highlight for favorites
On favorites tab you can see your films and characters and go into detail page of the film 

- [x] Task 1 - 4 - Done
- [ ] Task 5 - 6 - Not implemented yet

#### Todo:
- Plan for task 5 - Make a new filmsIn entity array to connect to characters as one to many relation. Which will list all the movies the character is in - (Different from films entity to avoid problems with favourite movies). Then use that to show in label and whenever the "alert" pops up
- Plan for task 6 - Implement hashable array to add the episode_id's into. Then find frequency of the episode_id's, use the one that is highest amount to recommend a movie 

#### Extra: 
- Fix so crawl text shows up in detail - Low priority
- Bad practice to use ViewDidLoad manual call. Only doing it in the DetailFilm page as it is controlled area for now. Will change later on


