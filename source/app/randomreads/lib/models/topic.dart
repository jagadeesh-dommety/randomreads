
enum Topic
{
    Mathematics,
    Physics,
    SpaceExploration,
    Chemistry,
    ArtificialIntelligence,
    SoftwareEngineering,
    Medicine,
    Engineering,
    EverydayTech,
    QuantumAndFutureTech,

    MarvelUniverse,
    DCUniverse,
    StarWars,
    HarryPotter,
    LordOfTheRings,
    Friends,
    BreakingBad,
    Anime,

    MusicLegends,
    KpopCulture,
    GamingHistory,
    Hollywood,

    StockMarket,
    PersonalFinance,
    CryptoAndBlockchain,

    FootballSoccer,
    NBABasketball,
    F1Racing,
    OlympicLegends,

    AmericanHistory,
    IndianHistory,
    EuropeanHistory,
    WorldWarsConflicts,
    AncientCivilizations,

    BrandEmpires,
    Entrepreneurs,
    Psychology,
    Humanities,
    BrainAndNeuroscience,

    Evolution,
    Environment,
    Wildlife,

    TrueCrime,
    BooksAndLiterature,
}
class TopicUtils {
  static const Map<Topic, String> displayNames = {
    Topic.Mathematics: "Mathematics",
    Topic.Physics: "Physics",
    Topic.SpaceExploration: "Space Exploration",
    Topic.Chemistry: "Chemistry",
    Topic.ArtificialIntelligence: "Artificial Intelligence",
    Topic.SoftwareEngineering: "Software Engineering",
    Topic.Medicine: "Medicine",
    Topic.Engineering: "Engineering",
    Topic.EverydayTech: "Everyday Tech",
    Topic.QuantumAndFutureTech: "Quantum and Future Tech",
    Topic.MarvelUniverse: "Marvel Universe" ,
    Topic.DCUniverse: "DC Universe",
    Topic.StarWars: "Star Wars" ,
    Topic.HarryPotter: "Harry Potter" ,
    Topic.LordOfTheRings: "Lord of the Rings" ,
    Topic.Friends: "Friends" ,
    Topic.BreakingBad: "Breaking Bad" ,
    Topic.Anime: "Anime" ,

    Topic.MusicLegends: "Music Legends" ,
    Topic.KpopCulture: "K-pop Culture" ,
    Topic.GamingHistory: "Gaming History" ,
    Topic.Hollywood: "Hollywood" ,

    Topic.StockMarket: "Stock Market" ,
    Topic.PersonalFinance: "Personal Finance" ,
    Topic.CryptoAndBlockchain: "Crypto & Blockchain" ,

    Topic.FootballSoccer: "Football (Soccer)" ,
    Topic.NBABasketball: "NBA Basketball" ,
    Topic.F1Racing: "F1 Racing" ,
    Topic.OlympicLegends: "Olympic Legends" ,

    Topic.AmericanHistory: "American History" ,
    Topic.IndianHistory: "Indian History" ,
    Topic.EuropeanHistory: "European History" ,
    Topic.WorldWarsConflicts: "World Wars & Global Conflicts" ,
    Topic.AncientCivilizations: "Ancient Civilizations" ,

    Topic.BrandEmpires: "Brand Empires" ,
    Topic.Entrepreneurs: "Entrepreneurs" ,

    Topic.Psychology: "Psychology" ,
    Topic.Humanities: "Humanities" ,
    Topic.BrainAndNeuroscience: "Brain & Neuroscience" ,

    Topic.Evolution: "Evolution" ,
    Topic.Environment: "Environment" ,
    Topic.Wildlife: "Wildlife" ,

    Topic.TrueCrime: "True Crime" ,
    Topic.BooksAndLiterature: "Books & Literature" 
    // Add other mappings as needed
  };
  // Helper to get display name from enum
  static String getDisplayName(Topic topic) {
    return displayNames[topic] ?? topic.toString().split('.').last;
  }

  static String getEnumFromDisplayName(String displayName) {
    return displayNames.entries
        .firstWhere((entry) => entry.value == displayName,
            orElse: () => const MapEntry(Topic.Mathematics, "Mathematics"))
        .key
        .toString()
        .split('.')
        .last;
  }

  static List<String> getAllTopicNames({bool sortbyPopular = false}) {
    var topiclist = Topic.values.map((topic) => getDisplayName(topic)).toList();
    if (!sortbyPopular) {
      topiclist.sort();
    }
    return topiclist;
  }
}