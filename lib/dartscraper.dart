class HtmlPage{
  String src;
  Tag rootTag;

  HtmlPage(String html){
    this.src = html;
    Initialize();
  }

  void Initialize(){
    int startPos = src.indexOf("<html");
    int endPos = src.indexOf("</html", startPos+1);
    endPos = src.indexOf(">", endPos+1)+1;
    rootTag = new Tag(src.substring(startPos, endPos));
  }
}

class Tag{
  String src;
  String type;
  String contents;
  Tag parent;
  List<Tag> children = new List<Tag>();

  Tag(String html, [parent = null]){
    this.src = html;
    this.parent = parent;
    _FindTagType();
    _FindContents();
    _FindChildrenAll();
  }

  Tag GetChildOnPosition(int position){
    if (children.length < position){
      return children[position];
    }
    return null;
  }

  Tag GetChildOfTypeOnPosition(String type, int position){
    for (var i = 0; i < children.length; i++){
      if (children[i].type == type){
        position--;
        if (position < 0){
          return children[i];
        }
      }
    }
    return null;
  }

  Tag GetChildOfType(String type, [bool recursive=false]){
    for (var i = 0; i < children.length; i++){
      if (children[i].type == type){
        return children[i];
      } else if (recursive && children[i].children.length > 0){
        Tag t = children[i].GetChildOfType(type, recursive);
        if (t != null){
          return t;
        }
      }
    }
    return null;
  }

  List<Tag> GetChildOfTypeAll(String type, [bool recursive=false]){
    List<Tag> tags = new List<Tag>();
    for (var i = 0; i < children.length; i++){
      if (children[i].type == type){
        tags.add(children[i]);
      } else if (recursive && children[i].children.length > 0){
        List<Tag> tagR = children[i].GetChildOfTypeAll(type, recursive);
        for (var i = 0; i < tagR.length; i++) {
          if (!tags.contains(tagR[i])) tags.add(tagR[i]);
        }
      }
    }
    return tags;
  }

  Tag GetChildWithAttributeExact(String attribute, String attributeValue, [bool recursive=false]){
    for (var i = 0; i < children.length; i++){
      if (children[i].GetAttribute(attribute) == attributeValue){
        return children[i];
      } else if (recursive && children[i].children.length > 0){
        Tag t = children[i].GetChildWithAttributeExact(attribute, attributeValue, recursive);
        if (t != null){
          return t;
        }
      }
    }
    return null;
  }

  List<Tag> GetChildWithAttributeExactAll(String attribute, String attributeValue, [bool recursive=false]){
    List<Tag> tags = new List<Tag>();
    for (var i = 0; i < children.length; i++){
      if (children[i].GetAttribute(attribute) == attributeValue){
        tags.add(children[i]);
      } else if (recursive && children[i].children.length > 0){
        List<Tag> tagR = children[i].GetChildWithAttributeExactAll(attribute, attributeValue, recursive);
        for (var i = 0; i < tagR.length; i++) {
          if (!tags.contains(tagR[i])) tags.add(tagR[i]);
        }
      }
    }
    return tags;
  }

  Tag GetChildWithAttribute(String attribute, String attributeValue, [bool recursive=false]){
    for (var i = 0; i < children.length; i++){
      String attr = children[i].GetAttribute(attribute);
      if (attr != null && attr.contains(attributeValue)){
        return children[i];
      } else if (recursive && children[i].children.length > 0){
        Tag t = children[i].GetChildWithAttribute(attribute, attributeValue, recursive);
        if (t != null){
          return t;
        }
      }
    }
    return null;
  }

  List<Tag> GetChildWithAttributeAll(String attribute, String attributeValue, [bool recursive=false]){
    List<Tag> tags = new List<Tag>();
    for (var i = 0; i < children.length; i++){
      String attr = children[i].GetAttribute(attribute);
      if (attr != null && attr.contains(attributeValue)){
        tags.add(children[i]);
      } else if (recursive && children[i].children.length > 0){
        List<Tag> tagR = children[i].GetChildWithAttributeAll(attribute, attributeValue, recursive);
        for (var i = 0; i < tagR.length; i++) {
          if (!tags.contains(tagR[i])) tags.add(tagR[i]);
        }
      }
    }
    return tags;
  }

  Tag GetChildWithAttributes(String attribute, List<String> attributeValues, [bool recursive=false]){
    for (var i = 0; i < children.length; i++){
      String attr = children[i].GetAttribute(attribute);
      for (var j = 0; j < attributeValues.length; j++) {
        if (attr != null && attr.contains(attributeValues[j])){
          if (j == attributeValues.length-1){
            return children[i];
          }
        } else{
          break;
        }
      }
      if (recursive && children[i].children.length > 0){
        Tag t = children[i].GetChildWithAttributes(attribute, attributeValues, recursive);
        if (t != null){
          return t;
        }
      }
    }
    return null;
  }

  List<Tag> GetChildWithAttributesAll(String attribute, List<String> attributeValues, [bool recursive=false]){
    List<Tag> tags = new List<Tag>();
    for (var i = 0; i < children.length; i++){
      String attr = children[i].GetAttribute(attribute);
      for (var j = 0; j < attributeValues.length; j++) {
        if (attr != null && attr.contains(attributeValues[j])){
          if (j == attributeValues.length-1){
            tags.add(children[i]);
          }
        } else{
          break;
        }
      }
      if (recursive && children[i].children.length > 0){
        List<Tag> tagR = children[i].GetChildWithAttributesAll(attribute, attributeValues, recursive);
        for (var i = 0; i < tagR.length; i++) {
          if (!tags.contains(tagR[i])) tags.add(tagR[i]);
        }
      }
    }
    return tags;
  }

  String GetAttribute(String type){
    String tag = src.substring(1, src.indexOf(">"));
    if (tag.contains(type)){
      int pos = 0;
      bool quoted = false;
      while (pos < tag.length){
        int quotePos = tag.indexOf("\"", pos);
        if (quotePos == -1){
          return null;
        }
        int typePos = tag.indexOf("$type", pos);
        if (quotePos < typePos){
          quoted = !quoted;
        } else if (quoted == false){
          return tag.substring(quotePos+1, tag.indexOf("\"", quotePos+1));
        } else{
          quoted = !quoted;
        }
        pos = quotePos+1;
      }
    } else{
      return null;
    }
    return null;
  }

  String TreeString(){
    String tree = "";
    void PrintT(int depth, Tag t){
      String p = "";
      for (var i = 0; i < depth; i++) {
        p += "  ";
      }
      p += t.src.substring(0, t.src.indexOf(">")+1);
      tree += p+"\n";
      for (var i = 0; i < t.children.length; i++) {
        PrintT(depth+1, t.children[i]);
      }
    }
    PrintT(0, this);
    return tree;
  }

  void _FindChildrenAll(){
    int startPos = src.indexOf(">")+1;
    while (startPos != -1){
      if (type == "script"){
        break;
      }
      startPos = src.indexOf(new RegExp("<[A-Za-z]"), startPos);
      if (startPos == -1){
        break;
      }
      String tagType = src.substring(startPos+1, src.indexOf(new RegExp("[ >]"), startPos+1));
      int depth = 1;
      int pos = startPos;
      int endPos = startPos+1;
      while (depth > 0){
        endPos = src.indexOf("</$tagType", pos);
        if (endPos == -1){
          endPos = pos+1;
        }
        pos = src.indexOf("<$tagType", pos+1);
        if (pos < endPos && pos != -1){
          depth++;
        } else{
          depth--;
          pos = endPos+1;
        }
      }
      endPos = src.indexOf(">", endPos+1)+1;
      children.add(new Tag(src.substring(startPos, endPos), this));
      startPos = endPos;
    }
  }

  void _FindTagType(){
    type = src.substring(1, src.indexOf(new RegExp("[ >]"), 1));
  }

  void _FindContents(){
    int depth = 1;
    int startPos = src.indexOf(">", 2)+1;
    int pos = startPos;
    int endPos = pos;
    if (startPos+1 > src.length){
      contents = "";
      return;
    }
    while (depth > 0){
      endPos = src.indexOf("</$type", pos);
      if (endPos == -1){
        endPos = pos+1;
      }
      pos = src.indexOf("<$type", pos+1);
      if (pos < endPos && pos != -1){
        depth++;
      } else{
        depth--;
        pos = endPos;
      }
    }
    contents = src.substring(startPos, endPos);
    contents = contents.replaceAll(new RegExp("<.+?(?=>)."), "");
  }
}