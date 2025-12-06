import 'package:randomreads/common/constants.dart';
import 'package:randomreads/models/readitem.dart';
import 'dart:convert';

import 'package:randomreads/services/http_service.dart';
// Remove: import 'package:http/http.dart' as http; (no longer needed directly)
// Add: import 'path/to/httpservice.dart'; // Adjust path as needed

class Getreadsservice {
  Future<ReadItem> fetchReadItem(String id) async {
    final url = "${Constants.apiBaseUrl}${Constants.fetchReadbyId}$id";
    final response = await HttpService.get(url);// Optional: pass custom headers if needed
    final data = jsonDecode(response.body);
    return ReadItem.fromJson(data);
  }

  Future<List<ReadItem>> fetchReads() async {
    const url = "${Constants.apiBaseUrl}${Constants.fetchReads}";
    final response = await HttpService.get(url);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => ReadItem.fromJson(e)).toList();
  }

  Future<List<ReadItem>> fetchReadsByTopic(String topic) async {
    final url = "${Constants.apiBaseUrl}${Constants.fetchreadsbytopic}$topic";
    final response = await HttpService.get(url);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => ReadItem.fromJson(e)).toList();
  }

  Future<List<ReadItem>> fetchsamplereaditems() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return [read1, read2, read3, read4, read5, read6];
  }

ReadItem read1 = ReadItem(
  id: "1",
  title: "The Endless Chase for Pi",
  content: '''In the misty dawn of 5th-century India, Aryabhata sat under a banyan tree in Pataliputra, scratching ratios on palm leaves. He measured a circle's edge against its width, landing on 3.1416—close enough to chart eclipses and sail the seas, a number he called "the constant" without fanfare. Word traveled west on spice routes, Arabic scholars like Al-Khwarizmi polishing it in Baghdad's House of Wisdom, dubbing it "qanatah" and weaving it into star maps by 800 AD.
Centuries ticked by, and Europe's minds joined the hunt: Archimedes in Sicily sketched polygons around circles, squeezing toward 3.1418 with 96 sides, his triangular method a grueling grind of geometry. By the 1600s, Ludolph van Ceulen etched 35 digits on his tombstone after 10 years of hand-cranking fractions, a badge of obsession. Then came Newton in his Cambridge attic, 1665 plague year, inventing calculus to slice the circle into infinite arcs—his series spat out 15 digits in days, a shortcut that unlocked orbits and engines.
Pi's digits stretch forever, irrational and wild, mocking our grasp. Yet in its loop, Aryabhata's whisper echoes—simple as a wheel's turn.
What curve in your day hides an endless unraveling?''',
  author: "Anonymous",
  isAiGenerated: true,
  topic: "Mathematics",
  likesCount: 100,
  shareCount: 21,
  reportCount: 12,
  createdAt: DateTime.now(),
);


ReadItem read2 = ReadItem(
  id: "2",
  title: "Stardust in Our Veins",
  content: '''It began with a whisper in the void, 13.8 billion years ago, when the Big Bang's roar cooled into a soup of hydrogen and helium, the universe's first breath. Gravity tugged at those scattered atoms, pulling them into vast clouds that swirled like cosmic cotton candy, collapsing under their own weight into the first stars—fiery nurseries where lighter elements fused into heavier kin: carbon for bones, oxygen for breath, iron for blood.''',
  author: "Anonymous",
  isAiGenerated: true,
  topic: "Astronomy",
  likesCount: 150,
  shareCount: 35,
  reportCount: 5,
  createdAt: DateTime.now(),
);

ReadItem read3 = ReadItem(
  id: "3",
  title: "The Boy Who Lived... As a Horcrux",
  content: '''Deep in Godric's Hollow on that stormy Halloween 1981, Voldemort descended like a shadow, his wand crackling green as Lily's plea hung unanswered. The Killing Curse struck baby Harry square, a bolt meant to end the boy who marked him as mortal. But love's old magic—Lily's sacrifice—rebounded the spell, shredding Voldemort's soul like glass under a hammer. As his body crumbled to ash, a ragged fragment latched onto the only living thing nearby: the wailing infant, burrowing into scar and spirit.
Rowling hinted at it in whispers: The diary's diary, the ring's curse, six anchors to cheat death. But the seventh? Unplanned, unintended—Harry, vessel to a splinter of the Dark Lord's rage and regret. It explained the whispers in his head, the basilisk's gaze spared, the Sorting Hat's pull toward Slytherin. Dumbledore knew, watching the boy unravel serpents and shadows not his own. In the Forbidden Forest's endgame, that piece fled back to its maker, leaving Harry whole but forever marked—a horcrux born of hate, undone by choice.
In the quiet after the castle fell silent, Harry touched his forehead. Some shadows cling, until you let them go.''',
  author: "Anonymous",
  isAiGenerated: true,
  topic: "Harry Potter",
  likesCount: 200,
  shareCount: 50,
  reportCount: 8,
  createdAt: DateTime.now(),
);

ReadItem read4 = ReadItem(
  id: "4",
  title: "The Unwritten Finale Toast",
  content: '''On the Warner Bros. backlot in May 2004, the fountain from Central Perk bubbled one last time as the cast gathered for the table read, scripts trembling in hands that had high-fived through a decade. "The Last One" unfolded on paper: Ross and Rachel's airport dash, Monica and Chandler's twins, Phoebe's final "Smelly Cat" strum—a tidy bow on lives we'd eavesdropped on since '94.''',
  author: "Anonymous",
  isAiGenerated: true,
  topic: "Friends",
  likesCount: 180,
  shareCount: 40,
  reportCount: 10,
  createdAt: DateTime.now(),
);

ReadItem read5 = ReadItem(
  id: "5",
  title: "The Clock That's Ticking Out",
  content: '''In the dim glow of Bell Labs in 1971, Dennis Ritchie and Ken Thompson coded Unix on a PDP-11, settling on a simple heartbeat: seconds since January 1, 1970—Unix time, a 32-bit counter for files, logs, everything. It fit on punch cards back then, powering servers that birthed the internet, your phone's wake-up chime, the stock tickers flashing billions in trades.''',
  author: "Anonymous",
  isAiGenerated: true,
  topic: "Software",
  likesCount: 120,
  shareCount: 25,
  reportCount: 7,
  createdAt: DateTime.now(),
);

ReadItem read6 = ReadItem(
  id: "6",
  title: "Moore's Law: The Marvel Behind Modern Electronics",
  content: '''IIf you’ve ever wondered why your phone from five years ago now feels like a potato, there’s a quiet hero behind that feeling: Moore’s Law. And its story actually starts with a simple observation made by Gordon Moore back in 1965, long before anyone imagined smartphones, AI, or binge‑watching.

Moore, who later co‑founded Intel, noticed something fascinating while studying early microchips. The number of transistors—those tiny on–off switches that make computing possible—was doubling roughly every year. He later stretched that to every two years, but the idea stuck. It wasn’t a scientific law, just a trend he spotted. Yet somehow, the entire tech industry took it as a challenge and said, “Alright, let’s make this happen.”

And they did. For decades.

The wild part? When Moore first made his prediction, transistors were still visible to the naked eye. Today, they’re measured in nanometers. A human hair is about 80,000 to 100,000 nanometers wide. Engineers now routinely place billions of 5‑nanometer transistors on a chip smaller than your fingernail. That’s the kind of progress that feels like science fiction if you say it out loud.

Getting to 5nm wasn’t just a matter of shrinking things. When you work at those scales, physics starts acting like a mischievous gremlin—electrons leak, heat spikes, and materials behave unpredictably. So engineers invented new tricks: 3D FinFET transistors that stick up like tiny fins, strange‑sounding materials like high‑k dielectrics, and mind‑bending manufacturing tools like extreme ultraviolet lithography, which basically etches circuits using light wavelengths far smaller than anything humans used before.

Even so, everyone knows we’re inching toward the wall. You can’t shrink transistors forever; eventually you hit the size of atoms. That’s why companies are now exploring new ideas—mixing different types of chips together, redesigning computer architectures, and experimenting with quantum computing. Moore’s Law may be fading, but its spirit is very much alive.

What makes this story compelling isn’t just the technology. It’s the people behind it—the engineers who stayed up nights trying to push boundaries a few more nanometers, and Gordon Moore, who made a prediction that ended up guiding an entire industry for half a century.

Moore’s Law isn’t really a law. It’s a promise humanity kept to itself: to keep pushing, shrinking, improving, and dreaming. And that journey is still unfolding today.
''',
  author: "Anonymous",
  isAiGenerated: true,
  topic: "Physics",
  likesCount: 140,
  shareCount: 30,
  reportCount: 6,
  createdAt: DateTime.now(),
);
}
