import 'package:xml/xml.dart';

extension XmlElementExtensions on XmlElement {
  XmlElement firstOrDefault(String elementName) {
    return this?.findAllElements(elementName)?.first ?? null;
  }

  String firstOrDefaultElementsAttribute(String elementName, String attributeName) {
    if (elementName?.isEmpty ?? true) {
      return null;
    }

    return this?.findElements(elementName)?.single?.firstOrDefaultAttributeValue(attributeName);
  }

  String firstOrDefaultAttributeValue(String attributeName) {
    if (attributeName?.isEmpty ?? true) {
      return null;
    }

    return this?.attributes?.firstWhere((attr) {
      return attr.name.local == attributeName;
    })?.value;
  }
}
