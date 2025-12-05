.NET 8 App service for service hosting
need redis cache - NO
CosmosDB
Postgresql

For MVP - Google sign in (not mandated)
User
  - Email
  - Gender
  - Age
  - steak count
  - Preferred topics
  - Last active time

Read
  - Id
  - title + Content
  - author
  - isAigenerated
  - Topic
  - Likes count
  - Share count
  - Report count
  - Createdat

UserActivity
  - Id - User+Readid
  - Topic
  - readtimes
  - readdate
  - HasViewed
  - HasLiked
  - HasReported
  - HasShared
  - TimeSpent
  - 

Topic
  - Partitionid - Topic
  - id - postid

---------------------------------------
based on useractivity and post-type get the topics recommended
    
