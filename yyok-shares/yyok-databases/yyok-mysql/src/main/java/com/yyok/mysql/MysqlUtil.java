package com.yyok.mysql;

public class MysqlUtil {

    public static String escapeAndWrapString(String value) {
        return escapeString(value, true);
    }

    public static String escapeString(String value) {
        return escapeString(value, false);
    }

    private static String escapeString(String value, boolean wrap) {
        int length = value.length();
        if (!isEscapeNeededForString(value, length)) {
            if (!wrap) {
                return value;
            }
            StringBuilder buf = new StringBuilder(length + 2);
            buf.append('\'').append(value).append('\'');
            return buf.toString();
        }

        StringBuilder buffer = new StringBuilder((int) (length * 1.1d));

        if (wrap) {
            buffer.append('\'');
        }

        for (int i = 0; i < length; ++i) {
            char c = value.charAt(i);
            switch (c) {
                case '\u0000':
                    buffer.append('\\');
                    buffer.append('0');
                    break;
                case '\n':
                    buffer.append('\\');
                    buffer.append('n');
                    break;
                case '\r':
                    buffer.append('\\');
                    buffer.append('r');
                    break;
                case '\u001a':
                    buffer.append('\\');
                    buffer.append('Z');
                    break;
                case '"':
                    /*
                     * Doesn't need to add '\', because we wrap string with "'"
                     * Assume that we don't use Ansi Mode
                     */
                    buffer.append('"');
                    break;
                case '\'':
                    buffer.append('\\');
                    buffer.append('\'');
                    break;
                case '\\':
                    buffer.append('\\');
                    buffer.append('\\');
                    break;
                default:
                    buffer.append(c);
                    break;
            }
        }

        if (wrap) {
            buffer.append('\'');
        }

        return buffer.toString();
    }

    public static boolean isEscapeNeededForString(String sql, int length) {
        boolean needsEscape = false;

        for (int i = 0; i < length; ++i) {
            char c = sql.charAt(i);
            switch (c) {
                case '\u0000':
                    needsEscape = true;
                    break;
                case '\n':
                    needsEscape = true;
                    break;
                case '\r':
                    needsEscape = true;
                    break;
                case '\u001a':
                    needsEscape = true;
                    break;
                case '\'':
                    needsEscape = true;
                    break;
                case '\\':
                    needsEscape = true;
                    break;
                default:
                    break;
            }

            if (needsEscape) {
                break;
            }
        }

        return needsEscape;
    }
}
