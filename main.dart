import 'package:dartscraper/dartscraper_io.dart';
import 'package:dartscraper/dartscraper.dart';
//import 'dart:io';

main (List<String> args) async{
  HtmlPage page = await GetHTML("https://www.reddit.com/");
  /*File f = new File("out.txt");
  f.writeAsStringSync(page.rootTag.TreeString());*/
  //Gets titles of the front page of reddit
  List<Tag> tags = page.rootTag.GetChildWithAttributeAll("class", "title may-blank", true);
  print("Found ${tags.length} matches.");
  for (var i = 0; i < tags.length; i++) {
    print("${tags[i].contents}");
  }
}