import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:dartscraper/dartscraper.dart';

Future<HtmlPage> GetHTML(String uri, {HttpClient httpClient}) async{
  HttpClient client;
  if (httpClient != null){
    client = httpClient;
  } else{
    client = new HttpClient();
  }
  HttpClientRequest request = await client.getUrl(Uri.parse(uri));
  HttpClientResponse response = await request.close();
  if (response.statusCode == HttpStatus.OK){
    var contents = await response.transform(UTF8.decoder).join();
    return new HtmlPage(contents);
  } else{
    return null;
  }
}