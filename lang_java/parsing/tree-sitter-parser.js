const Parser = require('tree-sitter');
const Java = require('../parsing/tree-sitter-java'); 

var myArgs = process.argv.slice(2);

var fs = require("fs");
const sourceCode = fs.readFileSync(myArgs[0]).toString();

const parser = new Parser();
parser.setLanguage(Java); 
const tree = parser.parse(sourceCode);

var lines = sourceCode.split("\n");

function get_chars(startRow, startCol, endRow, endCol) {
    var result = "";
    if (startRow == endRow) {
        result = lines[startRow].substring(startCol, endCol);
    } else {
        result = lines[startRow].substring(startCol);
        var k;
        for (k = startRow+1; k < endRow; k++) {
            result += lines[k];
        }
        result += lines[endRow].substring(0,endCol);
    }
    return result.trim();
}

function get_pos(startRow, startCol, endRow, endCol) {
    var result = "\"startrow\": " + startRow + ", \"startcol\": " + startCol + ", \"endrow\": " + endRow + ", \"endcol\": " + endCol;
    return result;
}

var extra = ["class_body","block","interface_body","interface_declaration","class_declaration","method_declaration","program"];

function traverse(obj) {
    if (obj == null) {
        return "}";
    }

    var ppline = "{\"type\": \"" + obj.type + "\", ";
    ppline += get_pos(obj.startPosition.row, obj.startPosition.column, obj.endPosition.row, obj.endPosition.column);

    if (!extra.includes(obj.type)) {
        ppline += ", \"value\": \"" + get_chars(obj.startPosition.row, obj.startPosition.column, obj.endPosition.row, obj.endPosition.column).replace(/\"/g,'\\"').replace(/\'/g,"\\'") + "\"";
    }

    if (obj["childCount"] > 0) {
        var j;
        ppline += ",\"body\":[";
        for (j = 0; j < obj["childCount"]; j = j+1) {
            ppline +=  traverse(obj.child(j)) + ",";
        }
        ppline = ppline.substring(0, ppline.length - 1);
        ppline += "]";
    } 

    return ppline + "}";
}

console.log(traverse(tree.rootNode));
