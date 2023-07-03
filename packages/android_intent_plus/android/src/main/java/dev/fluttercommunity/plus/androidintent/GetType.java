package dev.fluttercommunity.plus.androidintent;

//Use this class to get a generic type of an object at runtime
//https://stackoverflow.com/questions/3403909/get-generic-type-of-class-at-runtime
//And add support for primitive arrays and primitive types (ChatGPT)

import java.util.Objects;

public class GetType {

  static public String name(Class<?> type) {
    if (type.isArray() && Objects.requireNonNull(type.getComponentType()).isPrimitive()) {
      return type.getComponentType().getName() + "[]";
    } else if (type.isPrimitive()) {
      return getWrapperClass(type);
    } else {
      return type.toString();
    }
  }

  static private String getWrapperClass(Class<?> primitiveType) {
    if (primitiveType == boolean.class) {
      return "Boolean";
    } else if (primitiveType == byte.class) {
      return "Byte";
    } else if (primitiveType == char.class) {
      return "Character";
    } else if (primitiveType == short.class) {
      return "Short";
    } else if (primitiveType == int.class) {
      return "Integer";
    } else if (primitiveType == long.class) {
      return "Long";
    } else if (primitiveType == float.class) {
      return "Float";
    } else if (primitiveType == double.class) {
      return "Double";
    }
    return null;
  }
}
