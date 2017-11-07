import 'package:dartscraper/dartscraper_io.dart';
import 'package:dartscraper/dartscraper.dart';
import 'dart:io';

main (List<String> args) async{
  HtmlPage page = await GetHTML("http://lyrics.wikia.com/wiki/1000_Nadelstiche,_Volume_1_-_Amerikaner_%26_Briten_Singen_Deutsch_(2000)");
  Tag genre = page.rootTag.GetChildWithAttribute("title", "Genre", true);
  print(genre.contents);
  /*HtmlPage page = await GetHTML("https://www.reddit.com/");
  File f = new File("out.txt");
  f.writeAsStringSync(page.rootTag.TreeString());
  //Gets titles of the front page of reddit
  List<Tag> tags = page.rootTag.GetChildWithAttributeAll("class", "title may-blank", true);
  print("Found ${tags.length} matches.");
  for (var i = 0; i < tags.length; i++) {
    Tag commentsLink = tags[i].parent.parent.GetChildWithAttributes("class", ["comments", "may-blank"], true);
    print("${tags[i].contents} : ${commentsLink.GetAttribute("href")}");
  }*/
}