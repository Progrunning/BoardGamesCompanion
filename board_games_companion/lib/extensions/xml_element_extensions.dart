import 'package:xml/xml.dart';

extension XmlElementExtensions on XmlElement {
  XmlElement firstOrDefault(String elementName) {
    final element = this?.findElements(elementName);
    if (element?.isEmpty ?? true) {
      return null;
    }

    return element.first;
  }

  String firstOrDefaultElementsAttribute(
      String elementName, String attributeName) {
    if (elementName?.isEmpty ?? true) {
      return null;
    }

    final elements = this?.findElements(elementName);
    if(elements?.isEmpty ?? true) {
      return null;
    }

    return elements.single?.firstOrDefaultAttributeValue(attributeName);
  }

  XmlAttribute firstOrDefaultAttributeWhere(bool test(XmlAttribute element)) {
    return this.attributes?.firstWhere(test, orElse: null);
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
