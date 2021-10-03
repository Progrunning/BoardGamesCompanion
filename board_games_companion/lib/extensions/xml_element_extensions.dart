import 'package:collection/collection.dart' show IterableExtension;
import 'package:xml/xml.dart';

extension XmlElementExtensions on XmlElement? {
  XmlElement? firstOrDefault(String elementName) {
    final element = this?.findElements(elementName);
    if (element?.isEmpty ?? true) {
      return null;
    }

    return element!.first;
  }

  String? firstOrDefaultElementsAttribute(String? elementName, String attributeName) {
    if (elementName?.isEmpty ?? true) {
      return null;
    }

    final elements = this?.findElements(elementName!);
    if (elements?.isEmpty ?? true) {
      return null;
    }

    return elements!.single.firstOrDefaultAttributeValue(attributeName);
  }

  XmlAttribute? firstOrDefaultAttributeWhere(bool Function(XmlAttribute element) test) {
    if (this?.attributes.isEmpty ?? true) {
      return null;
    }

    return this!.attributes.firstWhereOrNull(test);
  }

  String? firstOrDefaultAttributeValue(String? attributeName) {
    if (attributeName?.isEmpty ?? true) {
      return null;
    }

    return firstOrDefaultAttributeWhere(
      (attr) {
        return attr.name.local == attributeName;
      },
    )?.value;
  }
}
