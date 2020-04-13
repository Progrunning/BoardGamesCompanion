import 'package:xml/xml.dart';

extension XmlElementExtensions on XmlElement {
  XmlElement firstOrDefault(String elementName) {
    return this?.findAllElements(elementName)?.first ?? null;
  }

  String firstOrDefaultElementsAttribute(String elementName) {
    if (elementName?.isNotEmpty ?? true) {
      return null;
    }

    return this?.findElements(elementName)?.single?.attributes?.single?.value;
  }

  String firstOrDefaultAttributeValue(String attributeName) {
    if (attributeName?.isNotEmpty ?? true) {
      return null;
    }

    return this?.attributes?.firstWhere((attr) {
      return attr.name.local == attributeName;
    })?.value;
  }
}
