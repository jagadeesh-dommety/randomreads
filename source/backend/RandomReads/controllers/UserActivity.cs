using RandomReads.Models;
/*
User activity where - it stores the 
user as pkey
readid as id

{
user - user1
id - read1
topic
iscompleted - true
timespent - 100
isshared - false
isliked - true
isreported - true
}
------------------------------------------
TopicActivity
Topic - pKey
readid as id
{
topic
id - readid
likes
reports
timespent
shares

}
*/

public class UserActivity
{
    public string userid {get; set;} //pk
    public Topic topic {get; set;}
    public string readid {get; set;} //id
    public bool iscompleted {get; set;}
    public int timespent {get; set;}
    public bool islike {get; set;}
    public bool ishared {get; set;} 
    public bool isreported {get; set;} 
}
