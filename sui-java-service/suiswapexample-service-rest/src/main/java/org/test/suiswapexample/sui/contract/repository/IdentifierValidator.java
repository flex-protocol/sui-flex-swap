package org.test.suiswapexample.sui.contract.repository;

public class IdentifierValidator {

    public static boolean isValidFieldName(String filedName) {
        if (filedName == null || filedName.isEmpty()) {
            return false;
        }
        char f = filedName.charAt(0);
        if (!(Character.isLetter(f) || '_' == f)) {
            //if (!Character.isJavaIdentifierStart(first)) {
            return false;
        }
        for (int i = 1; i < filedName.length(); i++) {
            char c = filedName.charAt(i);
            if (!(Character.isLetterOrDigit(c) || '_' == c)) {
                //if (!Character.isJavaIdentifierPart(ch)) {
                return false;
            }
        }
        return true;
    }

//    public static void main(String[] args) {
//        String fieldName = "_your_FieldName_1";
//        System.out.println(fieldName + " is a valid identifier: " + isValidFieldName(fieldName));
//        fieldName = "your_FieldName_1";
//        System.out.println(fieldName + " is a valid identifier: " + isValidFieldName(fieldName));
//        fieldName = "1your_FieldName_1";
//        System.out.println(fieldName + " is a valid identifier: " + isValidFieldName(fieldName));
//    }

}
