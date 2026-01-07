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
  - Createdat

Readstats
   - Likes count
   - Share count
   - Report count

UserActivity
  - 
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
    

Add slug to the cosmos db - read item - completed

---------------------------------------
Ensure there are no repeat of the articles, vectorization - completed

--------------------------------------

Search for topic - done

Search for story - 
Azure ai search - so users can search relevant stories (need more time and money)

-------------------------------

adding soft auth -completed
adding google auth - pending

------------------------------

Add userActivity for the read

  - Time spent on the read
  - iscompleted
  - Like
  - Report
  - Share


Read stats update
{
  "id": "read:read_123",
  "topic": "artificial-intelligence",
  "readId": "read_123",

  "totalTimeSpentSec": 98234,
  "uniqueReaders": 1245,

  "likesCount": 312,
  "sharesCount": 98,
  "reportsCount": 3,

  "completedCount": 876,

  "lastUpdatedAt": "2025-02-10T10:20:00Z"
}

----------------------------------------



resourceGroupName='randomreads'
accountName='<randomreads>'
readOnlyRoleDefinitionId = '00000000-0000-0000-0000-000000000002' # This is the ID of the Cosmos DB Built-in Data contributor role definition
principalId = "809a74ca-69da-4063-a0c1-6a612ec86415" # This is the object ID of the managed identity.
az cosmosdb sql role assignment create --account-name randomreads --resource-group randomreads --scope "/" --principal-id 809a74ca-69da-4063-a0c1-6a612ec86415 --role-definition-id 00000000-0000-0000-0000-000000000002

//az cosmosdb sql role assignment create --resource-group randomreads  --account-name randomreads   --scope "/"  --principal-id "72c9f7fd-e082-40ab-8513-8a7fb5cb3046" --role-definition-id "00000000-0000-0000-0000-000000000002"

//az role assignment create \
  --assignee 809a74ca-69da-4063-a0c1-6a612ec86415 \
  --role "Cognitive Services OpenAI Contributor" \
  --scope /subscriptions/9487cd81-9520-47e2-941d-2cfc4dda3b30/resourceGroups/randomreads/providers/Microsoft.CognitiveServices/accounts/randomreads-content-resource

  /subscriptions/9487cd81-9520-47e2-941d-2cfc4dda3b30/resourceGroups/randomreads/providers/Microsoft.CognitiveServices/accounts/randomreads-content-resource


  //SHA1 - 48:89:A1:DD:A5:25:32:4D:A3:9D:1F:47:92:8C:ED:82:39:83:AC:B6


  //No subscriptions in f8cdef31-a31e-4b4a-93e4-5f571e91255a (f8cdef31-a31e-4b4a-93e4-5f571e91255a) directory - Switch to another directory.

  ---